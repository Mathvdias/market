import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final List<Widget> children;
  final double itemExtent;

  const CarouselWidget({
    super.key,
    required this.children,
    required this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemExtent: itemExtent,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
