import 'package:cafeteriauth/models/product.dart';
import 'package:cafeteriauth/screens/product_detail_page.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryPage({super.key, required this.categoryTitle});

  List<Widget> _buildCategoryItems(BuildContext context) {
    final Map<String, List<Product>> items = {
      '🍳 Desayunos': [
        const Product(name: 'Huevos con Jamón', price: 60.00, description: 'Dos huevos estrellados sobre una cama de jamón de pavo, acompañados de frijoles refritos y totopos.', imageUrl: '-'),
        const Product(name: 'Chilaquiles Rojos', price: 75.00, description: 'Totopos de maíz bañados en nuestra salsa roja especial, con crema, queso fresco y cebolla.', imageUrl: '-'),
      ],
      '🍽️ Comidas': [
        const Product(name: 'Enchiladas Suizas', price: 110.00, description: 'Tres enchiladas rellenas de pollo, bañadas en una cremosa salsa verde y gratinadas con queso manchego.', imageUrl: '-'),
      ],
      '🍟 Snacks': [
        const Product(name: 'Papas a la Francesa', price: 50.00, description: 'Una generosa porción de papas fritas, crujientes por fuera y suaves por dentro.', imageUrl: '-'),
      ],
      '🍰 Postres': [
        const Product(name: 'Pastel de Chocolate', price: 55.00, description: 'Una rebanada de nuestro famoso pastel de chocolate, húmedo y con un rico betún de fudge.', imageUrl: '-'),
      ],
      '☕ Cafés': [
        const Product(name: 'Latte', price: 45.00, description: 'Nuestro clásico latte, con un shot de espresso y leche vaporizada.', imageUrl: '-'),
        const Product(name: 'Cappuccino', price: 45.00, description: 'Un balance perfecto de espresso, leche vaporizada y una capa generosa de espuma.', imageUrl: '-'),
        const Product(name: 'Espresso Americano', price: 30.00, description: 'Un shot de espresso diluido en agua caliente. Sabor intenso y directo.', imageUrl: '-'),
        const Product(name: 'Mocha', price: 50.00, description: 'Una deliciosa mezcla de espresso, chocolate y leche vaporizada, coronada con crema batida.', imageUrl: '-'),
      ]
    };

    final categoryItems = items[categoryTitle] ?? [];

    if (categoryItems.isEmpty) {
      return [const Center(child: Text('No hay productos en esta categoría.'))];
    }

    return categoryItems.map((product) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('\$${product.price.toStringAsFixed(2)} MXN'), 
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView(padding: const EdgeInsets.all(8.0), children: _buildCategoryItems(context)),
    );
  }
}
