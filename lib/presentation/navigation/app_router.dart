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

/// Route names.
abstract class RouteNames {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const profileSetup = '/profile-setup';
  static const pinSetup = '/pin-setup';
  static const biometricSetup = '/biometric-setup';
  static const home = '/home';
  static const orderFlow = '/order-flow';
  static const wallet = '/wallet';
  static const tracking = '/tracking';
  static const admin= '/admin';
  static const mapTracking = '/map-tracking';
  static const notifications = '/notifications';
}

/// GoRouter provider — reactive routing based on auth state.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.uri.path;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;

      // Don't redirect while checking auth or during loading
      if (isLoading) return null;

      // All auth flow routes — user can freely navigate between these
      final authFlowRoutes = [
        RouteNames.onboarding,
        RouteNames.login,
        RouteNames.otp,
        RouteNames.profileSetup,
        RouteNames.pinSetup,
        RouteNames.biometricSetup,
        
        
      ];

      final isAuthFlowRoute = authFlowRoutes.contains(location);

      // If authenticated and still on an auth flow route → go home
      if (isAuthenticated && isAuthFlowRoute) {
        return RouteNames.home;
      }

      // If NOT authenticated and NOT on an auth flow route → go to login
      if (!isAuthenticated && !isAuthFlowRoute) {
        return RouteNames.login;
      }

      // Otherwise stay where you are
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        name: 'otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.pinSetup,
        name: 'pin-setup',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.biometricSetup,
        name: 'biometric-setup',
        builder: (context, state) => const BiometricSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.orderFlow,
        name: 'order-flow',
        builder: (context, state) => const OrderFlowScreen(),
      ),
      GoRoute(
         path: RouteNames.wallet,
         name: 'wallet',
         builder: (context, state) => const WalletScreen(),
),    
 GoRoute(
  path: '${RouteNames.tracking}/:orderId',
  name: 'tracking',
  builder: (context, state) {
    final orderId = state.pathParameters['orderId'] ?? '';
    return TrackingScreen(orderId: orderId);
  },
),
GoRoute(
  path: RouteNames.admin,
  name: 'admin',
  builder: (context, state) => const AdminDashboardScreen(),
),
GoRoute(
  path: '${RouteNames.mapTracking}/:orderId',
  name: 'map-tracking',
  builder: (context, state) {
    final orderId = state.pathParameters['orderId'] ?? '';
    return MapTrackingScreen(orderId: orderId);
  },
),
GoRoute(
  path: RouteNames.notifications,
  name: 'notifications',
  builder: (context, state) => const NotificationsScreen(),
),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFFF1744)),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.go(RouteNames.home),
              child: const Text(
                'Go Home',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
});