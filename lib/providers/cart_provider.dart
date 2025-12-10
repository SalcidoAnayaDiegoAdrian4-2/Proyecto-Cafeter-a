import 'package:cafeteriauth/models/product.dart';
import 'package:flutter/material.dart';

// --- CART PROVIDER SIMPLIFICADO Y A PRUEBA DE ERRORES ---
class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void add(Product item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Product item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  int get totalItemsInCart => _items.length;
}
