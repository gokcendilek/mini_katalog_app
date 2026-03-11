import 'product.dart';

class ProductDetailArgs {
  const ProductDetailArgs({required this.product, required this.inCart});

  final Product product;
  final bool inCart;
}
