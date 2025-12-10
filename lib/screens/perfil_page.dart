import 'package:cafeteriauth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil de Usuario'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? 'Invitado',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? 'Inicia sesión para ver tu información',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Divider(),
                if (user != null)
                  ...[
                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Mis Pedidos'),
                      subtitle: const Text('Ver historial de pedidos'),
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Mis Direcciones'),
                      subtitle: const Text('Administrar direcciones de envío'),
                      onTap: () {
                        Navigator.pushNamed(context, '/addresses');
                      },
                    ),
                    // --- BOTÓN DE MÉTODOS DE PAGO FUNCIONAL ---
                    ListTile(
                      leading: const Icon(Icons.payment),
                      title: const Text('Métodos de Pago'),
                      subtitle: const Text('Gestionar tarjetas y pagos'),
                      onTap: () {
                        Navigator.pushNamed(context, '/payment-methods');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                      onTap: () {
                        authProvider.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Has cerrado sesión.')),
                        );
                      },
                    ),
                  ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: const Text('Iniciar Sesión'),
                      onPressed: () => Navigator.pushNamed(context, '/inicio'),
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
