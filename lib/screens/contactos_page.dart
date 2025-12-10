import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactosPage extends StatelessWidget {
  const ContactosPage({super.key});

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {

      print('No se pudo lanzar $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
      ),
      body: ListView(
        children: [
      
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Teléfono'),
            subtitle: const Text('+1 234 567 890'),
            onTap: () => _launchURL('tel:+1234567890'), 
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Correo electrónico'),
            subtitle: const Text('contacto@cafeteriauth.com'),
            onTap: () => _launchURL('email:contacto@cafeteriauth.com'),
          ),
          const ListTile(
            // Este ListTile no es interactivo por ahora.
            leading: Icon(Icons.location_on),
            title: Text('Dirección'),
            subtitle: Text('Calle Falsa 123, Ciudad, País'),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Sitio Web'),
            subtitle: const Text('www.cafeteriauth.com'),
            onTap: () => _launchURL('https://www.cafeteriauth.com'),
          ),
        ],
      ),
    );
  }
}
