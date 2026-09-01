import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/navigation/app_router.dart';
import 'providers/auth/auth_provider.dart';
import 'services/api/dio_client.dart';
import 'services/local/hive_service.dart';
import 'services/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF353935),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await Hive.initFlutter();
  await HiveService.initialize();

  runApp(
    const ProviderScope(
      child: FuelRushApp(),
    ),
  );
}

class FuelRushApp extends ConsumerWidget {
  const FuelRushApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DioClient.initialize(
      onTokenRefresh: (refreshToken) async {
        final repo = ref.read(authRepositoryProvider);
        return repo.refreshToken(refreshToken);
      },
      onAuthFailure: () {
        ref.read(authStateProvider.notifier).logout();
      },
    );

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'FUELRUSH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF353935),
        primaryColor: const Color(0xFFFF6B35),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}