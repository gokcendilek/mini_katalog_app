import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.inCart,
    required this.onTap,
    required this.onToggle,
    this.compact = false,
    this.dense = false,
  });

  final Product product;
  final bool inCart;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final price = product.price.toStringAsFixed(2);
    final oldPrice = product.oldPrice;
    final hasDiscount = oldPrice != null && oldPrice > product.price;
    final oldPriceValue = oldPrice ?? product.price;
    final discountPercent = hasDiscount
        ? ((1 - (product.price / oldPrice)) * 100).round()
        : 0;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? (dense ? 5 : 6) : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: compact ? (dense ? 96 : 76) : 150,
                      width: double.infinity,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '%$discountPercent',
                          style: textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: compact ? (dense ? 2 : 3) : 8),
              Text(
                product.name,
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? (dense
                        ? textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600)
                        : textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600))
                    : textTheme.titleSmall,
              ),
              if (!compact && product.tagline.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (!compact) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (product.rating ?? 4.5).toStringAsFixed(1),
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '(${product.reviewCount ?? 120})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: compact ? (dense ? 3 : 4) : 6),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '$price TL',
                          style: (compact
                                  ? (dense
                                      ? textTheme.labelSmall
                                      : textTheme.bodySmall)
                                  : textTheme.bodyMedium)
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (hasDiscount)
                          Text(
                            '${oldPriceValue.toStringAsFixed(2)} TL',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (compact)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      iconSize: 16,
                      visualDensity: VisualDensity.compact,
                      onPressed: onToggle,
                      icon: Icon(
                        inCart
                            ? Icons.shopping_bag
                            : Icons.shopping_bag_outlined,
                      ),
                      tooltip: inCart ? 'Sepetten cikar' : 'Sepete ekle',
                    )
                  else
                    FilledButton(
                      onPressed: onToggle,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        visualDensity: VisualDensity.compact,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        inCart ? 'Sepette' : 'Sepete Ekle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              if (compact) ...[
                SizedBox(height: dense ? 1 : 2),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'Urun ayrintilarini gor',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: dense ? 10 : 11,
                    ),
                  ),
                ),
              ],
              if (!compact)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(product.category),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              if (!compact) ...[
                const SizedBox(height: 2),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'Urun ayrintilarini gor',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
