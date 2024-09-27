import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class ListProducts extends StatelessWidget {
  const ListProducts({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return ListTile(
            key: ValueKey(index),
            leading: const Icon(
              Icons.image,
              color: Colors.grey,
              size: 50,
            ),
            title: Text(product.name),
            subtitle: Text(product.brand),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product_details',
                arguments: product,
              );
            },
          );
        },
        childCount: products.length,
      ),
    );
  }
}
