import 'package:cafeteriauth/models/product.dart';
import 'package:cafeteriauth/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderData, child) {
          if (orderData.orders.isEmpty) {
            return const Center(
              child: Text('Aún no has realizado ningún pedido.', 
                style: TextStyle(fontSize: 18, color: Colors.grey)
              ),
            );
          }

          return ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => _OrderCard(order: orderData.orders[i]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isExpanded = false;

  String _getCategory(String productName) {
    final name = productName.toLowerCase();
    
    if (name.contains('huevo') || name.contains('jamón') || name.contains('chilaquil')) {
      return '🍳 Desayuno';
    } else if (name.contains('enchilada')) {
      return '🍽️ Comida';
    } else if (name.contains('papa') || name.contains('frit')) {
      return '🍟 Snack';
    } else if (name.contains('pastel')) {
      return '🍰 Postre';
    } else if (name.contains('café') || name.contains('latte') || 
               name.contains('cappuccino') || name.contains('espresso') || 
               name.contains('mocha') || name.contains('americano')) {
      return '☕ Café';
    } else if (name.contains('jugo') || name.contains('naranja')) {
      return '🥤 Bebida';
    }
    return 'General';
  }

  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'es_MX'
    );
    
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          // ENCABEZADO
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total
                Text(
                  'Total: ${priceFormatter.format(widget.order.totalAmount)} MXN',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Fecha y hora
                Text(
                  '${dateFormatter.format(widget.order.orderDate)} - ${timeFormatter.format(widget.order.orderDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Botón para expandir
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Línea divisoria
          Container(height: 1, color: Colors.grey[200]),
          
          // DETALLES EXPANDIDOS
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Productos comprados:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // LISTA DE PRODUCTOS
                  if (widget.order.products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No hay productos en este pedido',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        // Para cada producto
                        for (var i = 0; i < widget.order.products.length; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: i == widget.order.products.length - 1 ? 0 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NOMBRE DEL PRODUCTO
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                
                                const SizedBox(height: 6),
                                
                                // DETALLES 
                                Row(
                                  children: [
                                    // CATEGORÍA 
                                    Text(
                                      _getCategory(widget.order.products[i].name),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 12),
                                    
                                    // PRECIO
                                    Text(
                                      priceFormatter.format(widget.order.products[i].price),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // TOTAL DEL PEDIDO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // Total del pedido 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total del pedido:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              priceFormatter.format(widget.order.totalAmount),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}