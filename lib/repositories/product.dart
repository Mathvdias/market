import 'package:marketplace/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProductDetails(String name);
}
