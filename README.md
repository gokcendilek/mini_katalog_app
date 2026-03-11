# GokcenDilek

Flutter ile temel seviyede katalog uygulamasi. GridView tabanli urun listesi,
detay sayfasi ve basit sepet state guncellemesi icerir.

## Ozellikler
- Urun listeleme (GridView)
- Urun detayi sayfasi
- Sayfa gecisleri (Navigator + Route Arguments)
- Basit arama ve filtreleme
- Sepet butonu ile state guncelleme (simulasyon)
- JSON veri okuma (assets)

## Flutter Surumu
- Flutter 3.22.0 (Dart 3.4.0)

## Kurulum ve Calistirma
```bash
flutter pub get
flutter run
```

## Proje Yapisi
```
lib/
  app.dart
  data/
    product_repository.dart
  models/
    product.dart
    product_detail_args.dart
  pages/
    product_detail_page.dart
    product_list_page.dart
  widgets/
    product_card.dart
assets/
  data/products.json
  images/
```

## Ekran Goruntuleri
- `screenshots/` klasoru altina ekran goruntuleri :
- Eklenen dosyalar:
  - `screenshots/home_screen1.png`
  - `screenshots/home_products.png`
  - `screenshots/category.png`
  - `screenshots/profil.png`
  - `screenshots/cart_empty.png`
  - `screenshots/cart_with_item.png`
  - `screenshots/product_detail.png`

## Veri Kaynaklari
- Banner: https://wantapi.com/assets/banner.png
- Urun verileri: https://wantapi.com/products.php
