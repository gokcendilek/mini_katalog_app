class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.isFeatured,
    this.rating,
    this.reviewCount,
    this.oldPrice,
    this.isFastDelivery = false,
  });

  final String id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String category;
  final String image;
  final bool isFeatured;
  final double? rating;
  final int? reviewCount;
  final double? oldPrice;
  final bool isFastDelivery;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      image: json['image'] as String,
      isFeatured: json['isFeatured'] as bool,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      isFastDelivery: json['isFastDelivery'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'isFeatured': isFeatured,
      'rating': rating,
      'reviewCount': reviewCount,
      'oldPrice': oldPrice,
      'isFastDelivery': isFastDelivery,
    };
  }
}
