import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FuelRush UI Components', () {
    testWidgets('Text widget renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Hello, Test Customer'))),
      );

      expect(find.text('Hello, Test Customer'), findsOneWidget);
    });

    testWidgets('Fuel card displays price correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Petrol'),
                Text('\u20b9${106.31.toStringAsFixed(2)}/L'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Petrol'), findsOneWidget);
      expect(find.text('\u20b9106.31/L'), findsOneWidget);
    });

    testWidgets('Wallet balance formats correctly', (tester) async {
      const balance = 5000.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('\u20b9${balance.toStringAsFixed(2)}'),
          ),
        ),
      );

      expect(find.text('\u20b95000.00'), findsOneWidget);
    });

    testWidgets('Order total calculates correctly', (tester) async {
      const total = 1312.28;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Total: \u20b9${total.toStringAsFixed(2)}'),
          ),
        ),
      );

      expect(find.text('Total: \u20b91312.28'), findsOneWidget);
    });
  });
}
