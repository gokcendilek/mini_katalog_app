import 'package:flutter/material.dart';

import '../models/product_detail_args.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailArgs;
    final product = args.product;
    final price = product.price.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urun Detayi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (product.isFeatured)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'One Cikan',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (product.tagline.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              product.tagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$price TL',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              if (product.oldPrice != null && product.oldPrice! > product.price)
                Text(
                  '${product.oldPrice!.toStringAsFixed(2)} TL',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              const SizedBox(width: 12),
              Chip(label: Text(product.category)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 18,
                color: Colors.amber.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                (product.rating ?? 4.5).toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 6),
              Text(
                '(${product.reviewCount ?? 120} degerlendirme)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              if (product.isFastDelivery)
                const Chip(
                  label: Text('Hizli Teslimat'),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Ucretsiz kargo simule edilmistir.'),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: FilledButton.icon(
          onPressed: () {
            Navigator.pop(context, !args.inCart);
          },
          icon: Icon(
            args.inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
          ),
          label: Text(
            args.inCart ? 'Sepetten Cikar' : 'Sepete Ekle',
          ),
        ),
      ),
    );
  }
}
