import 'package:cafeteriauth/models/product.dart';
import 'package:cafeteriauth/providers/cart_provider.dart';
import 'package:cafeteriauth/providers/order_provider.dart';
import 'package:cafeteriauth/providers/promotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final promotionProvider = Provider.of<PromotionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text('Tu carrito está vacío.', 
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // SECCIÓN DE PRODUCTOS
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Productos en tu carrito:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                      // LISTA SIMPLE DE PRODUCTOS
                      ...cart.items.map((product) {
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)} MXN'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () {
                              cart.remove(product);
                            },
                          ),
                        );
                      }).toList(),
                      
                      const Divider(thickness: 1),
                    ],
                  ),
                ),
                _buildTotalCard(context, cart, promotionProvider),
              ],
            ),
    );
  }

  Widget _buildTotalCard(BuildContext context, CartProvider cart, PromotionProvider promotionProvider) {
    final applicablePromotions = promotionProvider.getApplicablePromotions(cart.items);
    
    // Calcular total con TODAS las promociones aplicables MÚLTIPLES VECES
    double calculateTotalWithPromotions() {
      double total = cart.totalPrice;
      List<Product> remainingProducts = List.from(cart.items);
      final Map<String, int> appliedPromotionCount = {};
      
      // Para cada tipo de promoción, aplicar tantas veces como sea posible
      for (var promotion in applicablePromotions) {
        // Contar cuántas veces podemos aplicar esta promoción
        int timesApplied = 0;
        
        while (true) {
          // Verificar si podemos aplicar la promoción otra vez
          bool canApply = true;
          final Map<String, int> neededProducts = {};
          
          // Contar productos necesarios para esta promoción
          for (var productName in promotion.requiredProductNames) {
            neededProducts[productName] = (neededProducts[productName] ?? 0) + 1;
          }
          
          // Verificar si tenemos todos los productos necesarios
          for (var product in remainingProducts) {
            if (neededProducts.containsKey(product.name) && neededProducts[product.name]! > 0) {
              neededProducts[product.name] = neededProducts[product.name]! - 1;
            }
          }
          
          // Verificar si encontramos todos los productos necesarios
          canApply = neededProducts.values.every((count) => count == 0);
          
          if (!canApply) {
            break; // No podemos aplicar esta promoción más veces
          }
          
          // Aplicar la promoción
          double priceOfPromotionProducts = 0;
          final List<Product> productsToRemove = [];
          final Map<String, int> productsToFind = {};
          
          // Resetear el contador de productos a encontrar
          for (var productName in promotion.requiredProductNames) {
            productsToFind[productName] = (productsToFind[productName] ?? 0) + 1;
          }
          
          // Encontrar y marcar productos para remover
          for (var product in remainingProducts) {
            if (productsToFind.containsKey(product.name) && productsToFind[product.name]! > 0) {
              priceOfPromotionProducts += product.price;
              productsToRemove.add(product);
              productsToFind[product.name] = productsToFind[product.name]! - 1;
              
              // Si ya encontramos todos los productos, salir
              if (productsToFind.values.every((count) => count == 0)) {
                break;
              }
            }
          }
          
          // Remover los productos usados en esta aplicación de la promoción
          for (var product in productsToRemove) {
            remainingProducts.remove(product);
          }
          
          // Aplicar el descuento
          total = total - priceOfPromotionProducts + promotion.discountPrice;
          timesApplied++;
          
          // Actualizar el contador de promociones aplicadas
          final promoKey = promotion.name;
          appliedPromotionCount[promoKey] = (appliedPromotionCount[promoKey] ?? 0) + 1;
        }
      }
      
      return total;
    }
    
    // Obtener información de promociones aplicadas para mostrar
    Map<String, Map<String, dynamic>> getAppliedPromotionsInfo() {
      final info = <String, Map<String, dynamic>>{};
      List<Product> remainingProducts = List.from(cart.items);
      
      for (var promotion in applicablePromotions) {
        int timesApplied = 0;
        double totalSavings = 0;
        
        while (true) {
          bool canApply = true;
          final Map<String, int> neededProducts = {};
          
          for (var productName in promotion.requiredProductNames) {
            neededProducts[productName] = (neededProducts[productName] ?? 0) + 1;
          }
          
          for (var product in remainingProducts) {
            if (neededProducts.containsKey(product.name) && neededProducts[product.name]! > 0) {
              neededProducts[product.name] = neededProducts[product.name]! - 1;
            }
          }
          
          canApply = neededProducts.values.every((count) => count == 0);
          
          if (!canApply) break;
          
          // Calcular ahorro para esta aplicación
          double originalPrice = 0;
          final Map<String, int> productsToFind = {};
          
          for (var productName in promotion.requiredProductNames) {
            productsToFind[productName] = (productsToFind[productName] ?? 0) + 1;
          }
          
          for (var product in remainingProducts) {
            if (productsToFind.containsKey(product.name) && productsToFind[product.name]! > 0) {
              originalPrice += product.price;
              productsToFind[product.name] = productsToFind[product.name]! - 1;
              
              if (productsToFind.values.every((count) => count == 0)) {
                break;
              }
            }
          }
          
          final savingForThis = originalPrice - promotion.discountPrice;
          totalSavings += savingForThis;
          timesApplied++;
          
          // Remover productos para la siguiente iteración
          for (var productName in promotion.requiredProductNames) {
            productsToFind[productName] = 1;
          }
          
          for (var product in List.from(remainingProducts)) {
            if (productsToFind.containsKey(product.name) && productsToFind[product.name]! > 0) {
              remainingProducts.remove(product);
              productsToFind[product.name] = productsToFind[product.name]! - 1;
              
              if (productsToFind.values.every((count) => count == 0)) {
                break;
              }
            }
          }
        }
        
        if (timesApplied > 0) {
          info[promotion.name] = {
            'promotion': promotion,
            'timesApplied': timesApplied,
            'totalSavings': totalSavings,
          };
        }
      }
      
      return info;
    }
    
    final totalWithPromotions = calculateTotalWithPromotions();
    final appliedPromotionsInfo = getAppliedPromotionsInfo();
    final hasPromotions = appliedPromotionsInfo.isNotEmpty;
    final savings = hasPromotions ? (cart.totalPrice - totalWithPromotions) : 0.0;

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar promociones aplicadas de forma simple (solo si hay)
            if (hasPromotions)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promociones aplicadas:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...appliedPromotionsInfo.values.map((info) {
                    final promotion = info['promotion'] as Promotion;
                    final timesApplied = info['timesApplied'] as int;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.orange, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              timesApplied > 1 
                                ? '${promotion.name} (x$timesApplied)' 
                                : promotion.name,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '-\$${(info['totalSavings'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              ),
            
            // Total original (solo si hay promociones)
            if (hasPromotions)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total original:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)} MXN',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            
            // Total final - SIEMPRE VERDE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalWithPromotions.toStringAsFixed(2)} MXN',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            // Mostrar ahorro solo si hay promociones
            if (hasPromotions && savings > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ahorras:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$${savings.toStringAsFixed(2)} MXN',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Botón para confirmar pedido
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  hasPromotions ? 'Confirmar Pedido con Promoción' : 'Confirmar Pedido',
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // Calcular el precio final considerando promociones
                  double finalPrice = totalWithPromotions;
                  
                  // Crear una nueva lista de productos
                  final List<Product> productsToOrder = [];
                  for (var item in cart.items) {
                    productsToOrder.add(Product(
                      name: item.name,
                      price: item.price,
                      description: item.description,
                      imageUrl: item.imageUrl,
                    ));
                  }
                  
                  // Si hay promociones, agregar notas especiales
                  if (hasPromotions) {
                    for (var info in appliedPromotionsInfo.values) {
                      final promotion = info['promotion'] as Promotion;
                      final timesApplied = info['timesApplied'] as int;
                      
                      if (timesApplied > 1) {
                        // Si se aplicó múltiples veces, agregar una entrada por cada aplicación
                        for (int i = 0; i < timesApplied; i++) {
                          productsToOrder.add(Product(
                            name: "[PROMO] ${promotion.name}",
                            price: promotion.discountPrice,
                            description: promotion.description,
                            imageUrl: promotion.imageUrl,
                          ));
                        }
                      } else {
                        productsToOrder.add(Product(
                          name: "[PROMO] ${promotion.name}",
                          price: promotion.discountPrice,
                          description: promotion.description,
                          imageUrl: promotion.imageUrl,
                        ));
                      }
                    }
                  }
                  
                  // Enviar al OrderProvider
                  Provider.of<OrderProvider>(context, listen: false).addOrder(
                    productsToOrder,
                    finalPrice,
                  );
                  
                  // Limpiar el carrito
                  cart.clear();
                  
                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        hasPromotions 
                          ? '¡Pedido confirmado con ${appliedPromotionsInfo.length} tipo(s) de promoción!' 
                          : '¡Pedido realizado con éxito!',
                      ),
                      backgroundColor: hasPromotions ? Colors.green : null,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  // Volver a la página principal
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}