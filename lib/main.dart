import 'package:flutter/material.dart';
import 'package:marketplace/controllers/theme.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/product.dart';
import 'package:marketplace/repositories/product_impl.dart';
import 'package:marketplace/repositories/user.dart';
import 'package:marketplace/repositories/user_impl.dart';
import 'package:marketplace/ui/login.dart';
import 'package:marketplace/ui/product_details.dart';
import 'package:marketplace/ui/products.dart';
import 'package:marketplace/ui/splash.dart';

void main() => runApp(const MarketPlaceApp());

class MarketPlaceApp extends StatefulWidget {
  const MarketPlaceApp({super.key});

  @override
  State<MarketPlaceApp> createState() => _MarketPlaceAppState();
}

class _MarketPlaceAppState extends State<MarketPlaceApp> {
  final UserRepository userRepository = MockUserRepository();
  final ProductRepository productRepository = MockProductRepository();
  final ThemeController themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) {
        return MaterialApp(
          themeMode: themeMode,
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
            '/products': (context) => ProductPage(
                  productRepository: productRepository,
                  themeController: themeController,
                ),
            '/product_details': (context) => ProductDetailsPage(
                  product:
                      ModalRoute.of(context)?.settings.arguments as Product,
                ),
          },
        );
      },
    );
  }
}
