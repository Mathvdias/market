import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brand: ${product.brand}"),
            Text("Model: ${product.model}"),
            Text("Color: ${product.color}"),
            Text("Size: ${product.size}"),
            Text("Description: ${product.description}"),
          ],
        ),
      ),
    );
  }
}
