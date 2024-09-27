import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/mocks/products.dart';
import 'package:marketplace/repositories/product.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<Product?> getProductDetails(String name) async {
    try {
      return productsJson
          .map((json) => Product.fromJson(json))
          .firstWhere((product) => product.name == name);
    } catch (e) {
      return null;
    }
  }
}
