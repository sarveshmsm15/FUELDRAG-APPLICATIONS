import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/auth_provider.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/auth/pin_setup_screen.dart';
import '../screens/auth/biometric_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/order/order_flow_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/tracking/tracking_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/tracking/map_tracking_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/puncture/puncture_screen.dart';
import '../screens/support/help_support_screen.dart';
import '../screens/profile/security_pin_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/profile/profile_screen.dart';

abstract class RouteNames {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const profileSetup = '/profile-setup';
  static const pinSetup = '/pin-setup';
  static const biometricSetup = '/biometric-setup';
  static const home = '/home';
  static const orders = '/orders';
  static const wallet = '/wallet';
  static const history = '/history';
  static const profile = '/profile';
  static const orderFlow = '/order-flow';
  static const tracking = '/tracking';
  static const admin = '/admin';
  static const mapTracking = '/map-tracking';
  static const notifications = '/notifications';
  static const puncture = '/puncture';
  static const helpSupport = '/help-support';
  static const securityPin = '/security-pin';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.uri.path;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;

      if (isLoading) return null;

      final authFlowRoutes = [
        RouteNames.onboarding, RouteNames.login, RouteNames.otp,
        RouteNames.profileSetup, RouteNames.pinSetup, RouteNames.biometricSetup,
      ];

      final isAuthFlowRoute = authFlowRoutes.contains(location);

      if (isAuthenticated && isAuthFlowRoute) return RouteNames.home;
      if (!isAuthenticated && !isAuthFlowRoute) return RouteNames.login;

      return null;
    },
    routes: [
      // Auth flow routes (no bottom nav)
      GoRoute(path: RouteNames.onboarding, name: 'onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: RouteNames.login, name: 'login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: RouteNames.otp, name: 'otp', builder: (c, s) {
        final phone = s.extra as String? ?? '';
        return OtpScreen(phone: phone);
      }),
      GoRoute(path: RouteNames.profileSetup, name: 'profile-setup', builder: (c, s) => const ProfileSetupScreen()),
      GoRoute(path: RouteNames.pinSetup, name: 'pin-setup', builder: (c, s) => const PinSetupScreen()),
      GoRoute(path: RouteNames.biometricSetup, name: 'biometric-setup', builder: (c, s) => const BiometricSetupScreen()),

      // Full-screen routes (no bottom nav)
      GoRoute(path: RouteNames.orderFlow, name: 'order-flow', builder: (c, s) => const OrderFlowScreen()),
      GoRoute(path: '${RouteNames.tracking}/:orderId', name: 'tracking', builder: (c, s) {
        return TrackingScreen(orderId: s.pathParameters['orderId'] ?? '');
      }),
      GoRoute(path: RouteNames.admin, name: 'admin', builder: (c, s) => const AdminDashboardScreen()),
      GoRoute(path: '${RouteNames.mapTracking}/:orderId', name: 'map-tracking', builder: (c, s) {
        return MapTrackingScreen(orderId: s.pathParameters['orderId'] ?? '');
      }),
      GoRoute(path: RouteNames.notifications, name: 'notifications', builder: (c, s) => const NotificationsScreen()),
      GoRoute(path: RouteNames.puncture, name: 'puncture', builder: (c, s) => const PunctureScreen()),
      GoRoute(path: RouteNames.helpSupport, name: 'help-support', builder: (c, s) => const HelpSupportScreen()),
      GoRoute(path: RouteNames.securityPin, name: 'security-pin', builder: (c, s) => const SecurityPinScreen()),

      // Bottom nav shell with 5 tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _BottomNavShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.home, name: 'home', pageBuilder: (c, s) => const NoTransitionPage(child: HomeScreen()))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.orders, name: 'orders', pageBuilder: (c, s) => const NoTransitionPage(child: OrdersScreen()))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.wallet, name: 'wallet-tab', pageBuilder: (c, s) => const NoTransitionPage(child: WalletScreen()))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.notifications, name: 'notifications-tab', pageBuilder: (c, s) => const NoTransitionPage(child: NotificationsScreen()))]),
          StatefulShellBranch(routes: [GoRoute(path: RouteNames.profile, name: 'profile', pageBuilder: (c, s) => const NoTransitionPage(child: ProfileScreen()))]),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 48, color: Color(0xFF5C3A1E)),
        const SizedBox(height: 16),
        Text('Page not found: ${state.uri.path}', style: const TextStyle(color: Color(0xFF5C3A1E))),
        const SizedBox(height: 16),
        GestureDetector(onTap: () => context.go(RouteNames.home), child: const Text('Go Home', style: TextStyle(color: Color(0xFF8B6342), fontWeight: FontWeight.w600))),
      ])),
    ),
  );
});

// ─── Bottom Navigation Shell ───
class _BottomNavShell extends StatelessWidget {
  const _BottomNavShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const _brown = Color(0xFF5C3A1E);
  static const _brownLight = Color(0xFF8B6342);
  static const _glass = Color(0x60FFFFFF);
  static const _glassBorder = Color(0x80FFFFFF);

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xF0F5EDE4),
              border: Border(top: BorderSide(color: _brown.withValues(alpha: 0.08), width: 1)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                    _navItem(1, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Orders'),
                    _navItem(2, Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined, 'Wallet'),
                    _navItem(3, Icons.notifications_rounded, Icons.notifications_outlined, 'Notifications'),
                    _navItem(4, Icons.person_rounded, Icons.person_outlined, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? _brown : _brownLight.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () => _goBranch(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(color: _brown.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : inactiveIcon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}
