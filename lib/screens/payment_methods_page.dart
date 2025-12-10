import 'package:cafeteriauth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de Pago'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.paymentMethods.isEmpty) {
            return const Center(
              child: Text('No tienes métodos de pago guardados.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: userProvider.paymentMethods.length,
            itemBuilder: (ctx, i) {
              final pm = userProvider.paymentMethods[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text(pm.alias, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tarjeta que termina en ${pm.cardNumber.substring(pm.cardNumber.length - 4)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar Eliminación'),
                          content: const Text('¿Estás seguro de que quieres eliminar este método de pago?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            TextButton(
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                userProvider.removePaymentMethod(pm.id);
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // --- BOTÓN FLOTANTE FUNCIONAL ---
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_card),
        onPressed: () {
          Navigator.pushNamed(context, '/add-payment-method');
        },
      ),
    );
  }
}
