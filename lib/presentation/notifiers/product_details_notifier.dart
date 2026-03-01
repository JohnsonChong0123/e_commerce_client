import 'package:flutter/material.dart';

class ProductDetailsNotifier extends ChangeNotifier {
  int _quantity;
  final double _price;

  ProductDetailsNotifier({int initialQuantity = 1, required double price})
    : _quantity = initialQuantity,
      _price = price;

  int get quantity => _quantity;
  double get price => _price * _quantity;

  void addQuantity() {
    _quantity++;
    notifyListeners();
  }

  void minusQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}
