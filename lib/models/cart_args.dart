import 'product.dart';

class CartArgs {
  const CartArgs({
    required this.products,
    required this.cartIds,
  });

  final List<Product> products;
  final Set<String> cartIds;
}
