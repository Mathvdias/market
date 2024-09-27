import 'package:flutter/material.dart';
import 'package:marketplace/controllers/theme.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/product.dart';
import 'package:marketplace/widgets/carousel.dart';
import 'package:marketplace/widgets/grid_products.dart';
import 'package:marketplace/widgets/list_products.dart';
import 'package:marketplace/widgets/search.dart';

class ProductPage extends StatefulWidget {
  final ProductRepository productRepository;
  final ThemeController themeController;

  const ProductPage({
    super.key,
    required this.productRepository,
    required this.themeController,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<bool> isGridView;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    isGridView = ValueNotifier(false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    isGridView.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userName =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, $userName"),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeController,
            builder: (context, themeMode, child) {
              bool isDarkMode = themeMode == ThemeMode.dark;
              return IconButton(
                isSelected: isDarkMode,
                onPressed: () {
                  widget.themeController.toggleTheme(!isDarkMode);
                },
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.brightness_2_outlined),
              );
            },
          ),
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
      body: FutureBuilder<List<Product>>(
        future: widget.productRepository.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return CustomScrollView(
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ofertas Recomendadas",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const CarouselWidget(),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Produtos",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isGridView,
                          builder: (context, isGrid, child) {
                            return IconButton(
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.list_view,
                                progress: _animationController,
                              ),
                              onPressed: () {
                                isGridView.value = !isGrid;
                                if (isGridView.value) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isGridView,
                  builder: (context, isGrid, child) {
                    return isGrid
                        ? GridProducts(products: products)
                        : ListProducts(products: products);
                  },
                ),
              ],
            );
          }

          return const Center(child: Text("No products found."));
        },
      ),
    );
  }
}
