import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_auth/local_auth.dart';

import '../../../services/api/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPinScreen extends ConsumerStatefulWidget {
  const SecurityPinScreen({super.key});
  @override
  ConsumerState<SecurityPinScreen> createState() => _SecurityPinScreenState();
}

class _SecurityPinScreenState extends ConsumerState<SecurityPinScreen> {
  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _brownDark = Color(0xFF3E2210);
  static const _glass = Color(0x40FFFFFF);
  static const _glassBorder = Color(0x60FFFFFF);

  bool _biometricEnabled = false;
  bool _loginAlerts = true;
  String _sessionTimeout = '15 min';
  bool _hasPin = false;
  bool _isLoading = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _loadSettings();
  }

  Future<void> _checkBiometric() async {
    try {
      final auth = LocalAuthentication();
      final available = await auth.canCheckBiometrics;
      final enrolled = await auth.getAvailableBiometrics();
      setState(() {
        _biometricAvailable = available && enrolled.isNotEmpty;
      });
    } catch (_) {}
  }

  Future<void> _loadSettings() async {
    try {
      final res = await DioClient.instance.get('/auth/me');
      final data = (res.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
      if (data != null && mounted) {
        setState(() {
          _hasPin = data['hasPin'] == true || data['pinSet'] == true;
          _biometricEnabled = data['biometricEnabled'] == true;
        });
      }
    } catch (_) {}
  }

  Future<void> _changePin() async {
    final result = await _showPinSetupDialog();
    if (result == null) return;
    setState(() => _isLoading = true);
    try {
      await DioClient.instance.post('/security/pin/setup', data: result);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_pin', true);
      if (mounted) {
        setState(() => _hasPin = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN set successfully!'), backgroundColor: Color(0xFF2E7D32)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e'), backgroundColor: const Color(0xFFFF1744)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _disablePin() async {
    final pin = await _showPinDialog('Enter Current PIN', 'Enter your PIN to disable');
    if (pin == null) return;
    try {
      await DioClient.instance.post('/security/pin/disable', data: {'pin': pin});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_pin', false);
      if (mounted) {
        setState(() => _hasPin = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN disabled'), backgroundColor: Color(0xFF2E7D32)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e'), backgroundColor: const Color(0xFFFF1744)));
    }
  }

  Future<Map<String, String>?> _showPinSetupDialog() async {
    String pin = '';
    String question = "What is your pet's name?";
    String answer = '';
    final questions = ["What is your pet's name?", "What is your mother's maiden name?", "What city were you born in?", "What is your favorite food?", "What was your first school?"];

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFFF5EDE4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Set Up PIN & Security', style: TextStyle(color: _brownDark, fontWeight: FontWeight.w700, fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('PIN (4-6 digits)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight)),
              const SizedBox(height: 6),
              TextField(
                keyboardType: TextInputType.number, maxLength: 6, obscureText: true, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, letterSpacing: 6, fontWeight: FontWeight.w700, color: _brownDark),
                onChanged: (v) => setDlgState(() => pin = v),
                decoration: InputDecoration(hintText: '• • • •', counterText: '', hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.3), fontSize: 22, letterSpacing: 6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _brown.withValues(alpha: 0.2))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _brown, width: 2))),
              ),
              const SizedBox(height: 14),
              const Text('Security Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: question, isExpanded: true,
                items: questions.map((q) => DropdownMenuItem(value: q, child: Text(q, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) => setDlgState(() => question = v ?? question),
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _brown.withValues(alpha: 0.2)))),
              ),
              const SizedBox(height: 14),
              const Text('Your Answer', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _brownLight)),
              const SizedBox(height: 6),
              TextField(
                onChanged: (v) => setDlgState(() => answer = v),
                decoration: InputDecoration(hintText: 'Type your answer...', hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.4)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _brown.withValues(alpha: 0.2))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _brown, width: 2))),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: _brownLight))),
            ElevatedButton(
              onPressed: pin.length >= 4 && answer.isNotEmpty ? () => Navigator.pop(ctx, {'pin': pin, 'securityQuestion': question, 'securityAnswer': answer}) : null,
              style: ElevatedButton.styleFrom(backgroundColor: _brown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && _biometricAvailable) {
      try {
        final auth = LocalAuthentication();
        final didAuth = await auth.authenticate(localizedReason: 'Enable biometric login for FuelRush');
        if (didAuth) {
          await DioClient.instance.post('/auth/biometric/setup', data: {'enabled': true});
          setState(() => _biometricEnabled = true);
        }
      } catch (_) {}
    } else {
      try {
        await DioClient.instance.post('/auth/biometric/setup', data: {'enabled': false});
        setState(() => _biometricEnabled = false);
      } catch (_) {}
    }
  }

  Future<void> _changePassword() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF5EDE4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password', style: TextStyle(color: _brownDark, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'New password',
            hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _brown.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _brown, width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: _brownLight))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: _brown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      try {
        await DioClient.instance.put('/auth/profile', data: {'password': result});
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated!'), backgroundColor: Color(0xFF2E7D32)));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
      }
    }
  }

  Future<void> _selectSessionTimeout() async {
    final options = ['5 min', '15 min', '30 min', '1 hour', 'Never'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFFF5EDE4),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _brownLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('Session Timeout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark)),
          const SizedBox(height: 12),
          ...options.map((o) => ListTile(
            leading: Icon(Icons.timer_rounded, color: o == _sessionTimeout ? _brown : _brownLight.withValues(alpha: 0.4)),
            title: Text(o, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: o == _sessionTimeout ? _brown : _brownDark)),
            trailing: o == _sessionTimeout ? const Icon(Icons.check_circle_rounded, color: _brown) : null,
            onTap: () => Navigator.pop(ctx, o),
          )),
          const SizedBox(height: 16),
        ]),
      ),
    );
    if (selected != null) setState(() => _sessionTimeout = selected);
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF5EDE4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [Icon(Icons.warning_amber_rounded, color: Color(0xFFFF1744)), SizedBox(width: 8), Text('Delete Account?', style: TextStyle(color: _brownDark, fontWeight: FontWeight.w700))]),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.', style: TextStyle(color: _brownDark)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: _brownLight))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF1744), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await DioClient.instance.delete('/auth/account');
        if (mounted) context.go('/login');
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFFF1744)));
      }
    }
  }

  Future<String?> _showPinDialog(String title, String hint) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF5EDE4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: _brownDark, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.w700, color: _brownDark),
          decoration: InputDecoration(
            hintText: '• • • • • •',
            hintStyle: TextStyle(color: _brownLight.withValues(alpha: 0.3), fontSize: 24, letterSpacing: 8),
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _brown.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _brown, width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: _brownLight))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: _brown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFF8F0E8), Color(0xFFEDE0D4), Color(0xFFF5EDE4), Color(0xFFE8D5C4)], stops: [0.0, 0.3, 0.7, 1.0]),
        ),
        child: Stack(
          children: [
            _bubble(top: -40, right: -30, size: 140, opacity: 0.10),
            _bubble(bottom: 200, left: -40, size: 120, opacity: 0.08),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, color: _brown, size: 18),
                              ),
                            ),
                          ),
                        ),
                        const Text('Security & PIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(14), border: Border.all(color: _glassBorder)),
                                child: const Icon(Icons.notifications_outlined, color: _brown, size: 22),
                              ),
                            ),
                          ),
                          Positioned(right: 2, top: 2, child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle), child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, decoration: TextDecoration.none))))),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // App PIN Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text('App PIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _brownDark, decoration: TextDecoration.none)),
                                  const SizedBox(height: 4),
                                  Text('Secure your account with a\n${_hasPin ? "6" : "4"}-digit PIN', style: TextStyle(fontSize: 13, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none, height: 1.3)),
                                  const SizedBox(height: 12),
                                  Row(children: [
                                    GestureDetector(
                                      onTap: _changePin,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                        decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: _brown.withValues(alpha: 0.12))),
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(_hasPin ? 'Change PIN' : 'Set PIN', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _brown, decoration: TextDecoration.none)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.chevron_right_rounded, color: _brown, size: 16),
                                        ]),
                                      ),
                                    ),
                                    if (_hasPin) ...[
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: _disablePin,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                          decoration: BoxDecoration(color: const Color(0xFFFF1744).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF1744).withValues(alpha: 0.15))),
                                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                            Text('Turn Off', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFFF1744), decoration: TextDecoration.none)),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ]),
                                ]),
                              ),
                              const SizedBox(width: 16),
                              // PIN visual
                              Container(
                                width: 90, height: 90,
                                decoration: BoxDecoration(color: _brown.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(18), border: Border.all(color: _brown.withValues(alpha: 0.1))),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(_hasPin ? Icons.lock_rounded : Icons.lock_open_rounded, color: _brown, size: 28),
                                  const SizedBox(height: 4),
                                  Text(_hasPin ? '• • • •' : '○ ○ ○ ○', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _brown.withValues(alpha: 0.5), letterSpacing: 4, decoration: TextDecoration.none)),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 14),

                    // Biometric Login
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                          child: Row(children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.fingerprint_rounded, color: _brown, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Biometric Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              const SizedBox(height: 2),
                              Text('Use fingerprint or Face ID to\nlogin quickly and securely', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none, height: 1.3)),
                            ])),
                            Switch(
                              value: _biometricEnabled,
                              onChanged: _biometricAvailable ? _toggleBiometric : null,
                              activeTrackColor: _brown,
                              activeThumbColor: Colors.white,
                              inactiveTrackColor: _brownLight.withValues(alpha: 0.2),
                            ),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),

                    // Security Options
                    const Text('Security Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                          child: Column(children: [
                            _securityOption(Icons.verified_user_rounded, 'Login Alerts', 'Get notified about new logins', trailing: Text('On', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32), decoration: TextDecoration.none)), onTap: () => setState(() => _loginAlerts = !_loginAlerts)),
                            _dividerLine(),
                            _securityOption(Icons.lock_outline_rounded, 'Change Password', 'Update your account password', onTap: _changePassword),
                            _dividerLine(),
                            _securityOption(Icons.devices_rounded, 'Trusted Devices', 'Manage devices logged in to your account', onTap: () {}),
                            _dividerLine(),
                            _securityOption(Icons.timer_rounded, 'Session Timeout', 'Automatically log out after inactivity', trailing: Text(_sessionTimeout, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _brownLight, decoration: TextDecoration.none)), onTap: _selectSessionTimeout),
                            _dividerLine(),
                            _securityOption(Icons.delete_outline_rounded, 'Delete Account', 'Permanently delete your account', onTap: _deleteAccount),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),

                    // Privacy & Data
                    const Text('Privacy & Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(color: _glass, borderRadius: BorderRadius.circular(22), border: Border.all(color: _glassBorder)),
                          child: _securityOption(Icons.privacy_tip_rounded, 'Privacy Settings', 'Manage your privacy preferences', onTap: () {}),
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 20),

                    // Security priority banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [_brown.withValues(alpha: 0.08), _brown.withValues(alpha: 0.03)]),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: _brown.withValues(alpha: 0.12)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.verified_user_rounded, color: _brown, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Your security is our priority', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
                              const SizedBox(height: 3),
                              Text('We use bank-level encryption to keep your\naccount and data safe.', style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none, height: 1.3)),
                            ])),
                            // Shield decoration
                            Opacity(
                              opacity: 0.15,
                              child: const Icon(Icons.shield_rounded, color: _brown, size: 60),
                            ),
                          ]),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _securityOption(IconData icon, String title, String subtitle, {Widget? trailing, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: _brown.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: _brown, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brownDark, decoration: TextDecoration.none)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: _brownLight.withValues(alpha: 0.7), decoration: TextDecoration.none)),
          ])),
          if (trailing != null) ...[trailing, const SizedBox(width: 8)],
          Icon(Icons.chevron_right_rounded, color: _brownLight.withValues(alpha: 0.4), size: 22),
        ]),
      ),
    );
  }

  Widget _dividerLine() => Divider(height: 1, indent: 74, endIndent: 18, color: _brownLight.withValues(alpha: 0.1));

  Widget _bubble({double? top, double? bottom, double? left, double? right, required double size, required double opacity}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white.withValues(alpha: opacity + 0.1), Colors.white.withValues(alpha: opacity * 0.3)]), border: Border.all(color: Colors.white.withValues(alpha: opacity + 0.05))),
      ),
    );
  }
}
