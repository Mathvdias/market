import 'package:marketplace/models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProductDetails(String name);
}
