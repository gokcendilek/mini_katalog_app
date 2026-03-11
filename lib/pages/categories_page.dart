import 'package:flutter/material.dart';

import '../models/cart_args.dart';
import '../models/product.dart';
import '../models/product_detail_args.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/product_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late List<Product> _products;
  late Set<String> _cartIds;
  String _selectedCategory = 'Tum';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as CartArgs;
    _products = args.products;
    _cartIds = Set<String>.from(args.cartIds);
  }

  List<String> get _categories =>
      <String>{'Tum', ..._products.map((e) => e.category)}.toList()..sort();

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Tum') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  Future<void> _openCart() async {
    final result = await Navigator.pushNamed(
      context,
      '/cart',
      arguments: CartArgs(products: _products, cartIds: _cartIds),
    );
    if (result is Set<String>) {
      setState(() {
        _cartIds = result;
      });
    }
  }

  void _toggleCart(Product product) {
    setState(() {
      if (_cartIds.contains(product.id)) {
        _cartIds.remove(product.id);
      } else {
        _cartIds.add(product.id);
      }
    });
  }

  Future<void> _openDetail(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: ProductDetailArgs(
        product: product,
        inCart: _cartIds.contains(product.id),
      ),
    );
    if (result is bool) {
      setState(() {
        if (result) {
          _cartIds.add(product.id);
        } else {
          _cartIds.remove(product.id);
        }
      });
    }
  }

  void _onBottomTap(int index) {
    if (index == 0) {
      Navigator.pop(context, _cartIds);
      return;
    }
    if (index == 2) {
      _openCart();
      return;
    }
    if (index == 3) {
      Navigator.pushNamed(
        context,
        '/profile',
        arguments: CartArgs(products: _products, cartIds: _cartIds),
      ).then((result) {
        if (result is Set<String>) {
          setState(() {
            _cartIds = result;
          });
        }
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: _openCart,
          ),
        ],
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Populer Kategoriler',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _categories
                .map(
                  (category) => ChoiceChip(
                    label: Text(category),
                    selected: category == _selectedCategory,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Kategoriye Gore Urunler',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text('${_filteredProducts.length} urun'),
            ],
          ),
          const SizedBox(height: 12),
          if (_filteredProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Bu kategoride urun bulunamadi.')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                final inCart = _cartIds.contains(product.id);
                return ProductCard(
                  product: product,
                  inCart: inCart,
                  compact: true,
                  dense: true,
                  onTap: () => _openDetail(product),
                  onToggle: () {
                    _toggleCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          inCart ? 'Sepetten cikarildi.' : 'Sepete eklendi.',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          const SizedBox(height: 24),
          Text(
            'Kampanyalar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const _PromoTile(
            title: 'Sepette %10 Indirim',
            subtitle: 'Mobil uygulamaya ozel kupon',
            icon: Icons.local_offer_outlined,
          ),
          const SizedBox(height: 12),
          const _PromoTile(
            title: 'Hizli Teslimat',
            subtitle: 'Bugun kargoda urunler',
            icon: Icons.local_shipping_outlined,
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 1,
        onTap: _onBottomTap,
      ),
    );
  }
}

class _PromoTile extends StatelessWidget {
  const _PromoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
