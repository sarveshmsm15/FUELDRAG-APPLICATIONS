import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository());

final adminDashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(adminRepositoryProvider).getDashboard();
});

final adminRevenueProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(adminRepositoryProvider).getDailyRevenue();
});

final adminOrdersByStatusProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(adminRepositoryProvider).getOrdersByStatus();
});