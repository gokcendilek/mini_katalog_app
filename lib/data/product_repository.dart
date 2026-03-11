import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  static Future<List<Product>> loadProducts() async {
    final data = await rootBundle.loadString('assets/data/products.json');
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList()
        .asMap()
        .entries
        .map((entry) => _withCommerceMeta(entry.value, entry.key))
        .toList();
  }

  static Product _withCommerceMeta(Product product, int index) {
    final rating = product.rating ?? (4.2 + (index % 4) * 0.2);
    final reviewCount = product.reviewCount ?? (120 + index * 37);
    final oldPrice =
        product.oldPrice ?? (product.price * (1.15 + (index % 3) * 0.05));
    final isFastDelivery = product.isFastDelivery || index.isEven;

    return Product(
      id: product.id,
      name: product.name,
      tagline: product.tagline,
      description: product.description,
      price: product.price,
      category: product.category,
      image: product.image,
      isFeatured: product.isFeatured,
      rating: double.parse(rating.toStringAsFixed(1)),
      reviewCount: reviewCount,
      oldPrice: double.parse(oldPrice.toStringAsFixed(2)),
      isFastDelivery: isFastDelivery,
    );
  }
}
