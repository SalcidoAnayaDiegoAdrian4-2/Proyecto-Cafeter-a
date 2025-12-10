import 'package:flutter/material.dart';

// Modelo simple para representar un usuario.
class User {
  final String name;
  final String email;
  final String password; // En una app real, esto NUNCA se guarda en texto plano.

  User({required this.name, required this.email, required this.password});
}

class AuthProvider with ChangeNotifier {
  // --- SIMULACIÓN DE BASE DE DATOS ---
  final List<User> _users = [
    User(name: 'Santiago Test', email: 'santy@test.com', password: '123456')
  ];

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Método para registrar un nuevo usuario.
  Future<void> register(String name, String email, String password) async {
    // Se añade el nuevo usuario a nuestra lista simulada.
    _users.add(User(name: name, email: email, password: password));
    notifyListeners();
  }

  // Método para iniciar sesión.
  Future<bool> login(String email, String password) async {
    try {
      // Busca un usuario que coincida con el email y la contraseña.
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      _currentUser = user;
      notifyListeners();
      return true; // Inicio de sesión exitoso.
    } catch (e) {
      // Si no se encuentra ningún usuario, .firstWhere lanza una excepción.
      return false; // Inicio de sesión fallido.
    }
  }

  // Método para cerrar sesión.
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
