import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/fuel_repository.dart';

final fuelRepositoryProvider = Provider<FuelRepository>((ref) => FuelRepository());

final fuelRatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(fuelRepositoryProvider);
  return repo.getCurrentRates();
});