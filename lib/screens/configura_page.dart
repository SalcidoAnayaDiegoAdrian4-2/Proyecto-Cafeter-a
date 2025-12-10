import 'package:cafeteriauth/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- PÁGINA DE CONFIGURACIÓN  ---
class ConfiguraPage extends StatelessWidget {
  const ConfiguraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, settingsProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Configuración')),
          body: ListView(
            children: [
              // --- Control de Notificaciones ---
              SwitchListTile(
                title: const Text('Notificaciones'),
                subtitle: const Text('Recibir alertas de pedidos y promociones'),
                secondary: const Icon(Icons.notifications_active_outlined),
                value: settingsProvider.notificationsEnabled,
                onChanged: (bool value) {
                  settingsProvider.setNotifications(value);
                },
              ),
              const Divider(),
              // --- Control de Tema ---
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Tema de la aplicación'),
                trailing: DropdownButton<ThemeMode>(
                  value: settingsProvider.themeMode,
                  items: const [
                    DropdownMenuItem(value: ThemeMode.system, child: Text('Automático')),
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Oscuro')),
                  ],
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      settingsProvider.setThemeMode(newValue);
                    }
                  },
                ),
              ),
              const Divider(),
              // --- Control de Idioma ---
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Idioma'),
                trailing: DropdownButton<String>(
                  value: settingsProvider.language,
                  items: const [
                    DropdownMenuItem(value: 'Español', child: Text('Español')),
                    DropdownMenuItem(value: 'Inglés', child: Text('English')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settingsProvider.setLanguage(newValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Idioma cambiado a $newValue. Se requiere reiniciar la app para aplicar los cambios.')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
