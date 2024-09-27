import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';

class ProductSearch extends SearchDelegate<Product?> {
  final List<Product> products;

  ProductSearch(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      key: UniqueKey(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          key: ValueKey(index),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      key: UniqueKey(),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          key: ValueKey(index),
          title: Text(product.name),
          subtitle: Text(product.brand),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }
}
