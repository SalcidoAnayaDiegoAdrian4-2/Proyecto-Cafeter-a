import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  

  const Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
