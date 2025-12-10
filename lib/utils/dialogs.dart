import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Muestra un diálogo de confirmación para salir de la aplicación.
// Esta función puede ser llamada desde cualquier parte de la app que tenga acceso al 'context'.
Future<void> showExitConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // El usuario debe tocar un botón para cerrar.
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Salir de la aplicación'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra solo el diálogo.
            },
          ),
          TextButton(
            child: const Text('Sí, salir'),
            onPressed: () {
              SystemNavigator.pop(); // Cierra la aplicación.
            },
          ),
        ],
      );
    },
  );
}
