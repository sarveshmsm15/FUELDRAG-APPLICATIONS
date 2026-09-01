import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../providers/auth/auth_provider.dart';
import '../../navigation/app_router.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});
  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _error;

  @override
  void initState() { super.initState(); _focusNodes[0].requestFocus(); }

  @override
  void dispose() { for (final c in _controllers) c.dispose(); for (final f in _focusNodes) f.dispose(); super.dispose(); }

  String get _pin => _controllers.map((c) => c.text).join();

  Future<void> _setupPin() async {
    if (_pin.length != 6) { setState(() => _error = 'Please enter all 6 digits'); return; }
    setState(() { _isLoading = true; _error = null; });
    final result = await ref.read(authStateProvider.notifier).setupPin(_pin);
    if (mounted) {
      setState(() => _isLoading = false);
      if (result.success) context.go(RouteNames.biometricSetup);
      else setState(() => _error = result.message);
    }
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
    if (_pin.length == 6) _setupPin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.pin_rounded, color: Color(0xFFFF6B35), size: 32),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              const Text('Create a PIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 8),
              Text('This PIN secures your wallet & orders', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => SizedBox(
                  width: 48, height: 56,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x14FFFFFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _error != null ? const Color(0xFFFF1744) : const Color(0x1AFFFFFF)),
                        ),
                        child: TextField(
                          controller: _controllers[i], focusNode: _focusNodes[i],
                          textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 1, obscureText: true,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                          decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (v) => _onChanged(i, v),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (300 + i * 50).ms)),
              ),
              if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Color(0xFFFF1744), fontSize: 12))),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _isLoading ? null : _setupPin,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
                      ),
                      child: Center(
                        child: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFFF6B35)))
                          : const Text('SET PIN', style: TextStyle(color: Color(0xFFFF6B35), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go(RouteNames.biometricSetup),
                child: Text('Skip for now', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
              ).animate().fadeIn(delay: 700.ms),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}