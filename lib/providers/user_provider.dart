import 'dart:convert'; // Necesario para codificar y decodificar JSON
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- MODELOS CON CAPACIDAD DE CONVERTIRSE A/DESDE JSON ---

@immutable
class Address {
  final String id, street, city, state, zipCode, alias;

  const Address({ required this.id, required this.street, required this.city, required this.state, required this.zipCode, required this.alias });

  // Convierte un objeto Address a un mapa (JSON)
  Map<String, dynamic> toJson() => { 'id': id, 'street': street, 'city': city, 'state': state, 'zipCode': zipCode, 'alias': alias };

  // Crea un objeto Address desde un mapa (JSON)
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'], street: json['street'], city: json['city'], state: json['state'], zipCode: json['zipCode'], alias: json['alias'],
  );
}

@immutable
class PaymentMethod {
  final String id, cardNumber, expiryDate, cardHolderName, alias;

  const PaymentMethod({ required this.id, required this.cardNumber, required this.expiryDate, required this.cardHolderName, required this.alias });

  Map<String, dynamic> toJson() => { 'id': id, 'cardNumber': cardNumber, 'expiryDate': expiryDate, 'cardHolderName': cardHolderName, 'alias': alias };

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'], cardNumber: json['cardNumber'], expiryDate: json['expiryDate'], cardHolderName: json['cardHolderName'], alias: json['alias'],
  );
}

// --- PROVIDER CON PERSISTENCIA DE DATOS ---

class UserProvider with ChangeNotifier {
  List<Address> _addresses = [];
  List<PaymentMethod> _paymentMethods = [];

  static const _addressesKey = 'user_addresses';
  static const _paymentsKey = 'user_payments';

  UserProvider() {
    loadUserData(); // Carga todos los datos del usuario al iniciar
  }

  List<Address> get addresses => [..._addresses];
  List<PaymentMethod> get paymentMethods => [..._paymentMethods];

  Future<void> addAddress(Address address) async {
    _addresses.add(address);
    await _saveAddresses();
    notifyListeners();
  }

  Future<void> removeAddress(String id) async {
    _addresses.removeWhere((address) => address.id == id);
    await _saveAddresses();
    notifyListeners();
  }

  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    _paymentMethods.add(paymentMethod);
    await _savePaymentMethods();
    notifyListeners();
  }

  Future<void> removePaymentMethod(String id) async {
    _paymentMethods.removeWhere((pm) => pm.id == id);
    await _savePaymentMethods();
    notifyListeners();
  }

  // --- LÓGICA DE GUARDADO Y CARGA ---

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar Direcciones
    final addressesString = prefs.getString(_addressesKey);
    if (addressesString != null) {
      final List<dynamic> addressesJson = json.decode(addressesString);
      _addresses = addressesJson.map((json) => Address.fromJson(json)).toList();
    }

    // Cargar Métodos de Pago
    final paymentsString = prefs.getString(_paymentsKey);
    if (paymentsString != null) {
      final List<dynamic> paymentsJson = json.decode(paymentsString);
      _paymentMethods = paymentsJson.map((json) => PaymentMethod.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = _addresses.map((address) => address.toJson()).toList();
    await prefs.setString(_addressesKey, json.encode(addressesJson));
  }

  Future<void> _savePaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentsJson = _paymentMethods.map((pm) => pm.toJson()).toList();
    await prefs.setString(_paymentsKey, json.encode(paymentsJson));
  }
}
