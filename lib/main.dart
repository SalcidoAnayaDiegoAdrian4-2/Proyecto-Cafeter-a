import 'package:cafeteriauth/providers/auth_provider.dart';
import 'package:cafeteriauth/providers/cart_provider.dart';
import 'package:cafeteriauth/providers/order_provider.dart';
import 'package:cafeteriauth/providers/theme_provider.dart';
import 'package:cafeteriauth/providers/user_provider.dart';
import 'package:cafeteriauth/providers/promotion_provider.dart';
import 'package:cafeteriauth/screens/add_address_page.dart';
import 'package:cafeteriauth/screens/add_payment_method_page.dart';
import 'package:cafeteriauth/screens/addresses_page.dart';
import 'package:cafeteriauth/screens/cart_page.dart';
import 'package:cafeteriauth/screens/orders_page.dart';
import 'package:cafeteriauth/screens/payment_methods_page.dart';
import 'package:cafeteriauth/screens/perfil_page.dart';
import 'package:cafeteriauth/screens/registro_usuario.dart';
import 'package:flutter/material.dart';
import 'package:cafeteriauth/screens/configura_page.dart';
import 'package:cafeteriauth/screens/home_page.dart';
import 'package:cafeteriauth/screens/inicio_page.dart';
import 'package:cafeteriauth/screens/contactos_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PromotionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "Cafetería UTH",
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',  
            routes: {
              '/': (context) => const HomePage(), 
              '/inicio': (context) => const InicioPage(),
              '/configuracion': (context) => const ConfiguraPage(),
              '/contactos': (context) => const ContactosPage(),
              '/perfil': (context) => const PerfilPage(),
              '/cart': (context) => const CartPage(),
              '/registro': (context) => const RegistroUsuarioPage(),
              '/orders': (context) => const OrdersPage(),
              '/addresses': (context) => const AddressesPage(),
              '/add-address': (context) => const AddAddressPage(),
              '/payment-methods': (context) => const PaymentMethodsPage(),
              '/add-payment-method': (context) => const AddPaymentMethodPage(),
            },
          );
        },
      ),
    );
  }
}