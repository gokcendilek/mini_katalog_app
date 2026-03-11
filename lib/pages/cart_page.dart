import 'package:flutter/material.dart';

import '../models/cart_args.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Product> _products;
  late Set<String> _cartIds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as CartArgs;
    _products = args.products;
    _cartIds = Set<String>.from(args.cartIds);
  }

  List<Product> get _cartItems =>
      _products.where((item) => _cartIds.contains(item.id)).toList();

  double get _totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    final items = _cartItems;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _cartIds);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sepet'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context, _cartIds),
          ),
        ),
        body: items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 48),
                    const SizedBox(height: 12),
                    const Text('Sepetin su an bos.'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, _cartIds),
                      child: const Text('Urunlere Don'),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return _TotalSummary(total: _totalPrice);
                  }
                  final product = items[index];
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 56,
                          height: 56,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text('${product.price.toStringAsFixed(2)} TL'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Sepetten cikar',
                        onPressed: () {
                          setState(() {
                            _cartIds.remove(product.id);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
        bottomNavigationBar: items.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Odeme akisi demo amaclidir.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment_outlined),
                  label: const Text('Odemeye Gec'),
                ),
              ),
      ),
    );
  }
}

class _TotalSummary extends StatelessWidget {
  const _TotalSummary({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Toplam',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              '${total.toStringAsFixed(2)} TL',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
