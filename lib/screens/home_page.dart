import 'package:cafeteriauth/models/product.dart';
import 'package:cafeteriauth/providers/cart_provider.dart';
import 'package:cafeteriauth/providers/promotion_provider.dart';
import 'package:cafeteriauth/screens/category_page.dart';
import 'package:cafeteriauth/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final promotionProvider = Provider.of<PromotionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("CafeteriaUTH"),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Badge(
              label: Text(cart.totalItemsInCart.toString()),
              isLabelVisible: cart.items.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú Principal', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text('Inicio'), onTap: () => Navigator.pushNamed(context, '/inicio')),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Configuración'), onTap: () => Navigator.pushNamed(context, '/configuracion')),
            ListTile(leading: const Icon(Icons.person), title: const Text('Perfil'), onTap: () => Navigator.pushNamed(context, '/perfil')),
            ListTile(leading: const Icon(Icons.contacts), title: const Text('Contactos'), onTap: () => Navigator.pushNamed(context, '/contactos')),
            const Divider(),
            ListTile(leading: const Icon(Icons.exit_to_app), title: const Text('Salir'), onTap: () => showExitConfirmationDialog(context)),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Explora Nuestro Menú', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          // --- LISTVIEW HORIZONTAL PARA PROMOCIONES ---
          _buildSectionHeader('🔥 Promociones del Día'),
          SizedBox(
            height: 150, 
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                // Promoción 1 - Latte + Pastel 
                Card(
                  color: Colors.brown,
                  elevation: 4,
                  margin: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Latte + Pastel\n\$80',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Botón para agregar
                          ElevatedButton(
                            onPressed: () {
                              _addProductsForPromotion(context, ['Latte', 'Pastel de Chocolate']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            ),
                            child: const Text(
                              'Agregar',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Promoción 2 - Chilaquiles 2x1 
                Card(
                  color: Colors.red,
                  elevation: 4,
                  margin: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chilaquiles 2x1\n\$75',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Botón para agregar
                          ElevatedButton(
                            onPressed: () {
                              _addProductsForPromotion(context, ['Chilaquiles Rojos']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            ),
                            child: const Text(
                              'Agregar',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- LISTVIEW VERTICAL PARA CATEGORÍAS PRINCIPALES ---
          _buildSectionHeader('🍴 Nuestras Categorías'),
          _CategoryListItem(title: '🍳 Desayunos', icon: Icons.breakfast_dining, onTap: () => _navigateToCategory(context, '🍳 Desayunos')),
          _CategoryListItem(title: '🍽️ Comidas', icon: Icons.restaurant, onTap: () => _navigateToCategory(context, '🍽️ Comidas')),
          _CategoryListItem(title: '☕ Cafés', icon: Icons.coffee, onTap: () => _navigateToCategory(context, '☕ Cafés')),
          const SizedBox(height: 20),

          // --- OTRA LISTA PARA OTRAS CATEGORÍAS ---
          _buildSectionHeader(' snacking'),
          _CategoryListItem(title: '🍟 Snacks', icon: Icons.fastfood, onTap: () => _navigateToCategory(context, '🍟 Snacks')),
          _CategoryListItem(title: '🍰 Postres', icon: Icons.cake, onTap: () => _navigateToCategory(context, '🍰 Postres')),
        ],
      ),
    );
  }

  // Función para agregar productos necesarios para una promoción
  void _addProductsForPromotion(BuildContext context, List<String> productNames) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    bool allAdded = true;
    
    // Lista de productos disponibles
    final availableProducts = {
      'Latte': Product(
        name: 'Latte', 
        price: 45.00, 
        description: 'Nuestro clásico latte, con un shot de espresso y leche vaporizada.', 
        imageUrl: '-'
      ),
      'Pastel de Chocolate': Product(
        name: 'Pastel de Chocolate', 
        price: 55.00, 
        description: 'Una rebanada de nuestro famoso pastel de chocolate, húmedo y con un rico betún de fudge.', 
        imageUrl: '-'
      ),
      'Chilaquiles Rojos': Product(
        name: 'Chilaquiles Rojos', 
        price: 75.00, 
        description: 'Totopos de maíz bañados en nuestra salsa roja especial, con crema, queso fresco y cebolla.', 
        imageUrl: '-'
      ),
      
      'Enchiladas Suizas': Product(
        name: 'Enchiladas Suizas', 
        price: 110.00, 
        description: 'Tres enchiladas rellenas de pollo, bañadas en una cremosa salsa verde y gratinadas con queso manchego.', 
        imageUrl: '-'
      ),
      'Refresco': Product(
        name: 'Refresco', 
        price: 25.00, 
        description: 'Refresco de 600ml (Coca-Cola, Sprite, Fanta, etc.)', 
        imageUrl: '-'
      ),
    };
    
    for (var productName in productNames) {
      if (availableProducts.containsKey(productName)) {
        cartProvider.add(availableProducts[productName]!);
      } else {
        allAdded = false;
      }
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allAdded 
            ? '¡Productos agregados! Ve al carrito para aplicar la promoción.'
            : 'Algunos productos no están disponibles',
        ),
        backgroundColor: allAdded ? Colors.green : Colors.orange,
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String categoryTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryPage(categoryTitle: categoryTitle)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }
}

// --- WIDGETS PERSONALIZADOS ---

class _CategoryListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryListItem({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}