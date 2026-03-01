import 'package:e_commerce_client/presentation/notifiers/product_details_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProductDetailsNotifier notifier;
  late bool listenerCalled;
  late VoidCallback testListener;

  const double tPrice = 100.0;

  setUp(() {
    notifier = ProductDetailsNotifier(price: tPrice);
    listenerCalled = false;
    testListener = () {
      listenerCalled = true;
    };
    notifier.addListener(testListener);
  });
  tearDown(() {
    notifier.removeListener(testListener);
  });
  group('ProductDetailsNotifier', () {
    test('should initialize with correct quantity and price', () {
      expect(notifier.quantity, 1);
      expect(notifier.price, tPrice);
    });

    test('should initialize with custom quantity', () {
      const initialQuantity = 3;
      notifier = ProductDetailsNotifier(
        price: tPrice,
        initialQuantity: initialQuantity,
      );
      expect(notifier.quantity, initialQuantity);
      expect(notifier.price, tPrice * initialQuantity);
    });
  });

  group('addQuantity', () {
    test('should increase quantity and update price', () {
      notifier.addQuantity();
      expect(notifier.quantity, 2);
      expect(notifier.price, tPrice * 2);
      expect(listenerCalled, true);
    });

    test('should work correctly when called multiple times', () {
      notifier.addQuantity();
      notifier.addQuantity();
      notifier.addQuantity();
      notifier.addQuantity();
      expect(notifier.quantity, 5);
      expect(notifier.price, tPrice * 5);
      expect(listenerCalled, true);
    });
  });

  group('minusQuantity', () {
    test('should decrease quantity and update price', () {
      notifier.addQuantity(); // quantity = 2
      notifier.addQuantity(); // quantity = 3
      listenerCalled = false; // Reset listener flag
      notifier.minusQuantity(); // quantity = 2
      expect(notifier.quantity, 2);
      expect(notifier.price, tPrice * 2);
      expect(listenerCalled, true);
    });

    test('should not decrease quantity when quantity is 1', () {
      notifier.minusQuantity();
      expect(notifier.quantity, 1);
      expect(notifier.price, tPrice);
      expect(
        listenerCalled,
        false,
      ); // No change, so listener should not be called
    });

    test('should decrease from >1 to 1 correctly', () {
      notifier.addQuantity(); // quantity = 2
      listenerCalled = false; // Reset listener flag
      notifier.minusQuantity(); // quantity = 1
      expect(notifier.quantity, 1);
      expect(listenerCalled, true);
    });

    test('should handle multiple decrements from high quantity to 1', () {
      // Increment to 5
      for (int i = 0; i < 4; i++) {
        notifier.addQuantity();
      }
      expect(notifier.quantity, 5);

      // Decrement 4 times to 1
      for (int i = 0; i < 4; i++) {
        notifier.minusQuantity();
      }
      expect(notifier.quantity, 1);

      listenerCalled = false; // Reset listener flag
      notifier.minusQuantity(); // Try to decrement below 1
      expect(notifier.quantity, 1);
      expect(
        listenerCalled,
        false,
      ); // No change, so listener should not be called
    });
  });

  group('price calculation', () {
    test('should calculate price based on quantity', () {
      expect(notifier.price, tPrice); // quantity = 1
      notifier.addQuantity(); // quantity = 2
      expect(notifier.price, tPrice * 2);
      notifier.addQuantity(); // quantity = 3
      expect(notifier.price, tPrice * 3);
      notifier.minusQuantity(); // quantity = 2
      expect(notifier.price, tPrice * 2);
    });

    test('should work with different price values', () {
      const newPrice = 50.0;
      notifier = ProductDetailsNotifier(price: newPrice);
      expect(notifier.price, newPrice); // quantity = 1
      notifier.addQuantity(); // quantity = 2
      expect(notifier.price, newPrice * 2);
    });

    test(
      'should all receive notications when multiple listeners are added',
      () {
        bool secondListenerCalled = false;
        notifier.addListener(() {
          secondListenerCalled = true;
        });

        notifier.addQuantity();
        expect(listenerCalled, true);
        expect(secondListenerCalled, true);
      },
    );

    test('should not notify after listener is removed', () {
      notifier.removeListener(testListener);
      listenerCalled = false; // Reset listener flag
      notifier.addQuantity();
      expect(listenerCalled, false);
    });
  });
}
