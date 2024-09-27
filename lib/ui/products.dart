import 'package:flutter/material.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/product.dart';
import 'package:marketplace/widgets/search.dart';

class ProductPage extends StatefulWidget {
  final ProductRepository productRepository;

  const ProductPage({super.key, required this.productRepository});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final String userName =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, $userName"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final products = await widget.productRepository.getProducts();

              if (!context.mounted) return;
              showSearch(context: context, delegate: ProductSearch(products));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Produtos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: widget.productRepository.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return ListTile(
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

                return const Center(child: Text("No products found."));
              },
            ),
          ),
        ],
      ),
    );
  }
}
