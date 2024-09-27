import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/product.dart';
import 'package:marketplace/repositories/product_impl.dart';
import 'package:marketplace/repositories/user.dart';
import 'package:marketplace/repositories/user_impl.dart';
import 'package:marketplace/ui/login.dart';
import 'package:marketplace/ui/product_details.dart';
import 'package:marketplace/ui/products.dart';
import 'package:marketplace/ui/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = MockUserRepository();
  final ProductRepository productRepository = MockProductRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      title: 'Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(userRepository: userRepository),
        '/products': (context) =>
            ProductPage(productRepository: productRepository),
        '/product_details': (context) => ProductDetailsPage(
              product: ModalRoute.of(context)?.settings.arguments as Product,
            ),
      },
    );
  }
}
