import 'package:cafeteriauth/models/product.dart';
import 'package:flutter/foundation.dart';

// --- MODELO DE PEDIDO SIMPLIFICADO ---
class Order {
  final String id;
  final double totalAmount;
  final List<Product> products;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.totalAmount,
    required this.products,
    required this.orderDate,
  });
}

// --- PROVIDER DE PEDIDOS SIMPLIFICADO Y ROBUSTO ---
class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  // Ahora acepta una List<Product>, que es compatible con el nuevo CartProvider.
  void addOrder(List<Product> cartProducts, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        totalAmount: total,
        products: cartProducts,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
