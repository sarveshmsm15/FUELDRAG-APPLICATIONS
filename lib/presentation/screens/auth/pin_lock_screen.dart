import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api/dio_client.dart';

final pinLockProvider = StateNotifierProvider<PinLockNotifier, PinLockState>((ref) => PinLockNotifier());

class PinLockState {
  final bool hasPin;
  final bool isUnlocked;
  final bool isLoading;
  final String? error;
  const PinLockState({this.hasPin = false, this.isUnlocked = false, this.isLoading = false, this.error});
  PinLockState copyWith({bool? hasPin, bool? isUnlocked, bool? isLoading, String? error}) =>
    PinLockState(hasPin: hasPin ?? this.hasPin, isUnlocked: isUnlocked ?? this.isUnlocked, isLoading: isLoading ?? this.isLoading, error: error);
}

class PinLockNotifier extends StateNotifier<PinLockState> {
  PinLockNotifier() : super(const PinLockState()) {
    checkPinStatus();
  }

  Future<void> checkPinStatus() async {
    try {
      final res = await DioClient.instance.get('/security/pin-status');
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      state = state.copyWith(hasPin: data['hasPin'] == true, isUnlocked: data['hasPin'] != true);
    } catch (_) {
      // If API fails, check local cache
      final prefs = await SharedPreferences.getInstance();
      final hasPin = prefs.getBool('has_pin') ?? false;
      state = state.copyWith(hasPin: hasPin, isUnlocked: !hasPin);
    }
  }

  Future<bool> verifyPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await DioClient.instance.post('/security/pin/verify', data: {'pin': pin});
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      if (data['valid'] == true) {
        state = state.copyWith(isUnlocked: true, isLoading: false);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Wrong PIN. Try again.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Verification failed. Try again.');
      return false;
    }
  }

  void unlock() {
    state = state.copyWith(isUnlocked: true);
  }
}

class PinLockScreen extends ConsumerStatefulWidget {
  final VoidCallback onUnlocked;
  const PinLockScreen({super.key, required this.onUnlocked});
  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);

  String _enteredPin = '';
  bool _showRecovery = false;
  String? _securityQuestion;
  final _answerController = TextEditingController();
  final _newPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pinLockProvider.notifier).checkPinStatus();
    });
  }

  void _onDigit(int digit) {
    if (_enteredPin.length >= 6) return;
    setState(() => _enteredPin += digit.toString());
    if (_enteredPin.length >= 4) {
      _tryVerify();
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  Future<void> _tryVerify() async {
    final success = await ref.read(pinLockProvider.notifier).verifyPin(_enteredPin);
    if (success) {
      widget.onUnlocked();
    } else {
      setState(() => _enteredPin = '');
    }
  }

  Future<void> _loadSecurityQuestion() async {
    try {
      final res = await DioClient.instance.get('/security/question');
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      setState(() {
        _securityQuestion = data['question'] as String?;
        _showRecovery = true;
      });
    } catch (_) {
      setState(() => _showRecovery = true);
    }
  }

  Future<void> _recoverPin() async {
    final answer = _answerController.text.trim();
    final newPin = _newPinController.text.trim();
    if (answer.isEmpty || newPin.length < 4) return;
    try {
      await DioClient.instance.post('/security/recover', data: {'answer': answer, 'newPin': newPin});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_pin', true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN reset! Logging in...'), backgroundColor: Color(0xFF2E7D32)));
        ref.read(pinLockProvider.notifier).unlock();
        widget.onUnlocked();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong answer or error: $e'), backgroundColor: const Color(0xFFFF1744)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(pinLockProvider);

    if (lockState.isUnlocked) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0]),
        ),
        child: SafeArea(
          child: _showRecovery ? _buildRecovery() : _buildPinEntry(lockState),
        ),
      ),
    );
  }

  Widget _buildPinEntry(PinLockState lockState) {
    return Column(
      children: [
        const Spacer(flex: 2),
        // Lock icon
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: const Icon(Icons.lock_rounded, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 24),
        const Text('Enter Your PIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _brownDark)),
        const SizedBox(height: 8),
        Text('Enter your PIN to unlock FuelRush', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))),
        const SizedBox(height: 32),

        // PIN dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            final filled = i < _enteredPin.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: filled ? 18 : 16,
              height: filled ? 18 : 16,
              decoration: BoxDecoration(
                color: filled ? _brown : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: filled ? _brown : _brownLight.withValues(alpha: 0.3), width: 2),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // Error message
        if (lockState.error != null)
          Text(lockState.error!, style: const TextStyle(color: Color(0xFFFF1744), fontSize: 13, fontWeight: FontWeight.w600)).animate()..shakeX(),
        const SizedBox(height: 16),

        if (lockState.isLoading)
          const CircularProgressIndicator(color: _brown)
        else ...[
          // Numpad
          _buildNumpad(),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _loadSecurityQuestion,
            child: Text('Forgot PIN?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownLight.withValues(alpha: 0.7))),
          ),
        ],
        const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        for (int row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int col = 0; col < 3; col++)
                  _numKey(row, col),
              ],
            ),
          ),
      ],
    );
  }

  Widget _numKey(int row, int col) {
    final index = row * 3 + col;
    if (index < 9) {
      final num = index + 1;
      return _circleBtn('$num', () => _onDigit(num));
    } else if (index == 9) {
      return const SizedBox(width: 72, height: 72);
    } else if (index == 10) {
      return _circleBtn('0', () => _onDigit(0));
    } else {
      return GestureDetector(
        onTap: _onDelete,
        child: Container(
          width: 72, height: 72,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(shape: BoxShape.circle, color: _brown.withValues(alpha: 0.06)),
          child: const Icon(Icons.backspace_outlined, color: _brown, size: 24),
        ),
      );
    }
  }

  Widget _circleBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72, height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.5),
          border: Border.all(color: _brownLight.withValues(alpha: 0.15)),
        ),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: _brownDark))),
      ),
    );
  }

  Widget _buildRecovery() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() { _showRecovery = false; _answerController.clear(); _newPinController.clear(); }),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: _brown, size: 22),
          ),
          const SizedBox(height: 24),
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.security_rounded, color: _brown, size: 30),
          ),
          const SizedBox(height: 16),
          const Text('Recover Your PIN', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _brownDark)),
          const SizedBox(height: 6),
          Text('Answer your security question to reset your PIN', style: TextStyle(fontSize: 14, color: _brownLight.withValues(alpha: 0.7))),
          const SizedBox(height: 28),

          if (_securityQuestion != null) ...[
            Text('Security Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight.withValues(alpha: 0.7))),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: _brown.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: _brown.withValues(alpha: 0.1))),
              child: Text(_securityQuestion!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark)),
            ),
            const SizedBox(height: 20),
          ],

          Text('Your Answer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight.withValues(alpha: 0.7))),
          const SizedBox(height: 6),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.4)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _brown, width: 2)),
            ),
          ),
          const SizedBox(height: 20),

          Text('New PIN (4-6 digits)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight.withValues(alpha: 0.7))),
          const SizedBox(height: 6),
          TextField(
            controller: _newPinController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.w700, color: _brownDark),
            decoration: InputDecoration(
              hintText: '• • • •',
              hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.3), fontSize: 24, letterSpacing: 8),
              counterText: '',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _brown, width: 2)),
            ),
          ),
          const SizedBox(height: 28),

          GestureDetector(
            onTap: _recoverPin,
            child: Container(
              width: double.infinity, height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_brownLight, _brown, _brownDark]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: _brown.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: const Center(child: Text('Reset PIN', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800))),
            ),
          ),
        ],
      ),
    );
  }
}
