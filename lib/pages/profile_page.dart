import 'package:flutter/material.dart';

import '../models/cart_args.dart';
import '../models/product.dart';
import '../widgets/main_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Product> _products;
  late Set<String> _cartIds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as CartArgs;
    _products = args.products;
    _cartIds = Set<String>.from(args.cartIds);
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

  void _onBottomTap(int index) {
    if (index == 0) {
      Navigator.pop(context, _cartIds);
      return;
    }
    if (index == 2) {
      _openCart();
      return;
    }
    if (index == 1) {
      Navigator.pushNamed(
        context,
        '/categories',
        arguments: CartArgs(products: _products, cartIds: _cartIds),
      ).then((result) {
        if (result is Set<String>) {
          setState(() {
            _cartIds = result;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: _openCart,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  'GK',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gokcen Dilek',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'gold.uyelik@example.com',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _ProfileTile(
            title: 'Siparislerim',
            subtitle: 'Gecmis siparisleri gor',
            icon: Icons.receipt_long,
          ),
          const _ProfileTile(
            title: 'Adreslerim',
            subtitle: 'Teslimat adreslerini yonet',
            icon: Icons.location_on_outlined,
          ),
          const _ProfileTile(
            title: 'Odeme Yontemleri',
            subtitle: 'Kart ve odeme tercihleriniz',
            icon: Icons.credit_card,
          ),
          const _ProfileTile(
            title: 'Yardim Merkezi',
            subtitle: 'Canli destek ve SSS',
            icon: Icons.support_agent,
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 3,
        onTap: _onBottomTap,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
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
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
