import 'package:flutter_test/flutter_test.dart';

/// Mirrors the server pricing logic for client-side validation testing.
class PricingCalculator {
  static Map<String, double> calculate({
    required double pricePerLiter,
    required double quantityLiters,
    double distanceKm = 5.0,
    double surgeMultiplier = 1.0,
    double discountPercent = 0.0,
  }) {
    final basePrice = pricePerLiter * quantityLiters * surgeMultiplier;

    var deliveryFee = 49.0;
    if (distanceKm > 5) deliveryFee += (distanceKm - 5) * 10;
    if (distanceKm > 15) deliveryFee += (distanceKm - 15) * 5;

    final subtotal = basePrice + deliveryFee;
    final taxAmount = (subtotal * 0.18 * 100).round() / 100;
    final discountAmount = (subtotal * (discountPercent / 100) * 100).round() / 100;
    final totalAmount = ((subtotal + taxAmount - discountAmount) * 100).round() / 100;

    return {
      'basePrice': (basePrice * 100).round() / 100,
      'deliveryFee': deliveryFee,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
    };
  }
}

void main() {
  group('PricingCalculator', () {
    test('calculates basic 10L petrol at 5km', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 10,
      );

      expect(result['basePrice'], 1063.1);
      expect(result['deliveryFee'], 49.0);
      expect(result['taxAmount'], 200.18);
      expect(result['discountAmount'], 0.0);
      expect(result['totalAmount'], 1312.28);
    });

    test('applies surge multiplier correctly', () {
      final normal = PricingCalculator.calculate(pricePerLiter: 106.31, quantityLiters: 10);
      final surged = PricingCalculator.calculate(pricePerLiter: 106.31, quantityLiters: 10, surgeMultiplier: 1.5);

      expect(surged['basePrice']!, greaterThan(normal['basePrice']!));
      expect(surged['totalAmount']!, greaterThan(normal['totalAmount']!));
    });

    test('increases delivery fee for distance > 5km', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 10,
        distanceKm: 10,
      );

      expect(result['deliveryFee'], 99.0); // 49 + 5*10
    });

    test('applies discount correctly', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 10,
        discountPercent: 10,
      );

      expect(result['discountAmount']!, greaterThan(0));
      expect(result['totalAmount']!, lessThan(1312.28));
    });

    test('handles diesel pricing', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 94.27,
        quantityLiters: 20,
      );

      expect(result['basePrice'], 1885.4);
    });

    test('handles minimum 1L order', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 1,
      );

      expect(result['basePrice'], 106.31);
      expect(result['totalAmount']!, greaterThan(106.31));
    });

    test('never returns negative total even with 99% discount', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 1,
        discountPercent: 99,
      );

      expect(result['totalAmount']!, greaterThanOrEqualTo(0));
    });

    test('handles large distance > 15km', () {
      final result = PricingCalculator.calculate(
        pricePerLiter: 106.31,
        quantityLiters: 10,
        distanceKm: 20,
      );

      expect(result['deliveryFee'], 224.0); // 49 + 150 + 25
    });
  });
}
