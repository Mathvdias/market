class Product {
  final String name;
  final String brand;
  final String model;
  final String color;
  final String width;
  final String length;
  final String size;
  final String description;

  Product({
    required this.name,
    required this.brand,
    required this.model,
    required this.color,
    required this.width,
    required this.length,
    required this.size,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      width: json['width'],
      length: json['length'],
      size: json['size'],
      description: json['description'],
    );
  }
}
