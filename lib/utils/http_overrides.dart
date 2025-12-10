import 'dart:io';

// ADVERTENCIA: NO USAR EN PRODUCCIÓN.
// Esta clase se usa para ignorar los errores de certificado SSL durante el desarrollo.
// Esto es útil si un firewall o antivirus está bloqueando las conexiones HTTPS.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
