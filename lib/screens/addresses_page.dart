import 'package:cafeteriauth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.addresses.isEmpty) {
            return const Center(
              child: Text('No tienes direcciones guardadas.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: userProvider.addresses.length,
            itemBuilder: (ctx, i) {
              final address = userProvider.addresses[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(address.alias, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${address.street}, ${address.city}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar Eliminación'),
                          content: const Text('¿Estás seguro de que quieres eliminar esta dirección?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            TextButton(
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                userProvider.removeAddress(address.id);
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
      // --- BOTÓN FLOTANTE ---
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt_outlined),
        onPressed: () {
          Navigator.pushNamed(context, '/add-address');
        },
      ),
    );
  }
}
