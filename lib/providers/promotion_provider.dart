// lib/providers/promotion_provider.dart
import 'package:cafeteriauth/models/product.dart';
import 'package:flutter/foundation.dart';

// Modelo de Promoción
class Promotion {
  final String id;
  final String name;
  final List<String> requiredProductNames;
  final double discountPrice;
  final String description;
  final String imageUrl;

  Promotion({
    required this.id,
    required this.name,
    required this.requiredProductNames,
    required this.discountPrice,
    required this.description,
    this.imageUrl = '-',
  });

  // Verifica si esta promoción aplica para los productos en el carrito
  bool isApplicable(List<Product> cartItems) {
    final cartProductNames = cartItems.map((p) => p.name).toList();
    
    // Verifica si TODOS los productos requeridos están en el carrito
    for (var requiredProduct in requiredProductNames) {
      if (!cartProductNames.contains(requiredProduct)) {
        return false;
      }
    }
    
    return true;
  }

  // Calcula cuánto ahorra el usuario con esta promoción
  double calculateSavings(List<Product> cartItems) {
    double originalPrice = 0;
    
    // Suma el precio original de los productos requeridos
    for (var product in cartItems) {
      if (requiredProductNames.contains(product.name)) {
        originalPrice += product.price;
      }
    }
    
    return originalPrice - discountPrice;
  }
}

// Provider de Promociones
class PromotionProvider with ChangeNotifier {
  final List<Promotion> _availablePromotions = [
    Promotion(
      id: 'promo1',
      name: 'Combo Desayuno Especial',
      requiredProductNames: [
        'Huevos con Jamón',
        'Café',
      ],
      discountPrice: 80.00,
      description: 'Huevos con Jamón + Café Americano',
      imageUrl: '-',
    ),
    Promotion(
      id: 'promo2',
      name: 'Combo Café y Postre',
      requiredProductNames: [
        'Latte',
        'Pastel de Chocolate',
      ],
      discountPrice: 80.00,
      description: 'Latte + Pastel de Chocolate',
      imageUrl: '-',
    ),
    Promotion(
      id: 'promo3',
      name: 'Combo Comida Completa',
      requiredProductNames: [
        'Enchiladas Suizas',
        'Papas a la Francesa',
        'Refresco',
      ],
      discountPrice: 120.00,
      description: 'Enchiladas + Papas + Refresco',
      imageUrl: '-',
    ),
    Promotion(
      id: 'promo4',
      name: 'Promo 2x1 Chilaquiles',
      requiredProductNames: [
        'Chilaquiles Rojos',
      ],
      discountPrice: 75.00,
      description: 'Dos órdenes de Chilaquiles por el precio de una',
      imageUrl: '-',
    ),
  ];

  // Obtiene todas las promociones aplicables al carrito actual
  List<Promotion> getApplicablePromotions(List<Product> cartItems) {
    if (cartItems.isEmpty) return [];
    
    final applicable = <Promotion>[];
    
    for (var promotion in _availablePromotions) {
      if (promotion.isApplicable(cartItems)) {
        applicable.add(promotion);
      }
    }
    
    return applicable;
  }

  // Verifica si hay promociones disponibles para el carrito
  bool hasApplicablePromotions(List<Product> cartItems) {
    return getApplicablePromotions(cartItems).isNotEmpty;
  }

  // Obtiene la promoción con mayor descuento aplicable
  Promotion? getBestApplicablePromotion(List<Product> cartItems) {
    final applicable = getApplicablePromotions(cartItems);
    if (applicable.isEmpty) return null;
    
    // Ordena por mayor ahorro y toma la primera
    applicable.sort((a, b) {
      final savingsA = a.calculateSavings(cartItems);
      final savingsB = b.calculateSavings(cartItems);
      return savingsB.compareTo(savingsA);
    });
    
    return applicable.first;
  }
}