import 'package:flutter/material.dart';

import 'pages/cart_page.dart';
import 'pages/categories_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/product_list_page.dart';
import 'pages/profile_page.dart';

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
    );
    final textTheme = Typography.blackCupertino.copyWith(
      titleLarge: Typography.blackCupertino.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: Typography.blackCupertino.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
    return MaterialApp(
      title: 'GokcenDilek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: textTheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.surfaceContainerHighest,
          labelStyle: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      routes: {
        '/': (context) => const ProductListPage(),
        '/detail': (context) => const ProductDetailPage(),
        '/cart': (context) => const CartPage(),
        '/categories': (context) => const CategoriesPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
