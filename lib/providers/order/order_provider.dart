import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) => OrderRepository());

/// Selected fuel type for the current order flow.
final selectedFuelTypeProvider = NotifierProvider<SelectedFuelType, String?>(
  SelectedFuelType.new,
);

class SelectedFuelType extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? type) => state = type;
}

/// Selected quantity in liters.
final selectedQuantityProvider = NotifierProvider<SelectedQuantity, double>(
  SelectedQuantity.new,
);

class SelectedQuantity extends Notifier<double> {
  @override
  double build() => 10.0;

  void set(double qty) => state = qty;
}

/// Current active order.
final activeOrderProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getActiveOrder();
});