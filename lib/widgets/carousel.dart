import 'package:flutter/material.dart';
import 'package:marketplace/repositories/mocks/images.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
    );
  }
}
