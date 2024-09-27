import 'package:flutter/material.dart';
import 'package:marketplace/controllers/theme.dart';
import 'package:marketplace/models/product.dart';
import 'package:marketplace/repositories/mocks/images.dart';
import 'package:marketplace/repositories/product.dart';
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
                SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: CarouselView(
                      key: UniqueKey(),
                      padding: const EdgeInsets.all(16.0),
                      itemExtent: 330,
                      shrinkExtent: 200,
                      children: promotions.map((promotion) {
                        return Image.network(
                          key: ValueKey(promotion),
                          promotion,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
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
                        ? SliverPadding(
                            padding: const EdgeInsets.all(16.0),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = products[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/product_details',
                                              arguments: product,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              const Expanded(
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(product.name),
                                                    Text(product.brand),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: products.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 0.75,
                              ),
                            ),
                          )
                        : SliverList(
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
