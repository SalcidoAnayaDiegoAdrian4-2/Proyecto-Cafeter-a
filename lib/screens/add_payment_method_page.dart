import 'package:cafeteriauth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  @override
  void dispose() {
    _aliasController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newPaymentMethod = PaymentMethod(
        id: DateTime.now().toString(),
        alias: _aliasController.text,
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryDateController.text,
        cardHolderName: _cardHolderNameController.text,
      );
      Provider.of<UserProvider>(context, listen: false).addPaymentMethod(newPaymentMethod);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Método de Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(labelText: 'Alias (ej. Visa Débito)'),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Número de Tarjeta'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(labelText: 'Fecha de Vencimiento (MM/AA)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(labelText: 'Nombre del Titular'),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Guardar Método de Pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
