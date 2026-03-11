import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../models/cart_args.dart';
import '../models/product_detail_args.dart';
import '../widgets/product_card.dart';
import '../widgets/gift_store_banner.dart';
import '../widgets/main_bottom_nav.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final Future<List<Product>> _productsFuture;
  Set<String> _cartIds = {};
  List<Product> _products = [];
  String _query = '';
  String _selectedCategory = 'Tum';
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository.loadProducts();
    _productsFuture.then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _products = value;
      });
    });
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

  Future<void> _openCart() async {
    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Urunler yukleniyor...')),
      );
      return;
    }
    final result = await Navigator.pushNamed(
      context,
      '/cart',
      arguments: CartArgs(products: _products, cartIds: _cartIds),
    );
    if (result is Set<String>) {
      setState(() {
        _cartIds = result;
        _bottomIndex = 0;
      });
    }
  }

  void _onBottomTap(int index) {
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
    setState(() {
      _bottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GokcenDilek'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: _openCart,
                ),
                if (_cartIds.isNotEmpty)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      _cartIds.length.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Urunler yuklenemedi.'));
          }
          final products = snapshot.data ?? [];
          final featured = products.where((product) => product.isFeatured);
          final categories = <String>{'Tum', ...products.map((e) => e.category)}
              .toList();
          final filtered = products.where((product) {
            final query = _query.trim().toLowerCase();
            if (query.isEmpty) {
              return _selectedCategory == 'Tum' ||
                  product.category == _selectedCategory;
            }
            final matchesQuery = product.name.toLowerCase().contains(query) ||
                product.category.toLowerCase().contains(query);
            final matchesCategory = _selectedCategory == 'Tum' ||
                product.category == _selectedCategory;
            return matchesQuery && matchesCategory;
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 16),
                    const GiftStoreBanner(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Urun veya kategori ara',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == _selectedCategory;
                          return ChoiceChip(
                            label: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _CampaignCard(
                              title: 'Sepette %15 Indirim',
                              subtitle: '1000 TL uzeri alisveriste',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CampaignCard(
                              title: 'Kupon: KARGO50',
                              subtitle: 'Kargo indirimi yakala',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (featured.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              'One Cikanlar',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Text('${featured.length} urun'),
                          ],
                        ),
                      ),
                    if (featured.isNotEmpty)
                      SizedBox(
                        height: 210,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: featured.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final product = featured.elementAt(index);
                            final inCart = _cartIds.contains(product.id);
                            return SizedBox(
                              width: 170,
                              child: ProductCard(
                                product: product,
                                inCart: inCart,
                                onTap: () => _openDetail(product),
                                compact: true,
                                onToggle: () {
                                  _toggleCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        inCart
                                            ? 'Sepetten cikarildi.'
                                            : 'Sepete eklendi.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            'Urunler',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Text('${filtered.length} urun'),
                        ],
                      ),
                    ),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Sonuc bulunamadi.')),
                      )
                    else
                      GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
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
                                    inCart
                                        ? 'Sepetten cikarildi.'
                                        : 'Sepete eklendi.',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _bottomIndex,
        onTap: _onBottomTap,
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            'Detaylari Gor',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}
