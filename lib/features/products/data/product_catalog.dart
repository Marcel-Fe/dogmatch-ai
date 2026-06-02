import 'package:dogmatch_ai/features/breeds/domain/dog_breed.dart';

/// Kuratierte Produkt-Empfehlung (Fellbuerste oder Futter). Preise sind
/// RICHTWERTE, keine Live-Preise - ein Partnerprogramm ist (noch) nicht
/// angebunden. Der Link fuehrt zu einer Such-/Produktseite.
class ProductRecommendation {
  const ProductRecommendation({
    required this.title,
    required this.subtitle,
    required this.priceHintEur,
    required this.imageUrl,
    required this.shopUrl,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String priceHintEur;
  final String imageUrl;
  final String shopUrl;
  final ProductKind kind;
}

enum ProductKind { brush, food }

/// Liefert passende Produkte zu einer Rasse - gematcht ueber Felltyp,
/// Fellpflege-Bedarf und Groesse, damit es fuer ALLE Rassen funktioniert,
/// ohne jede einzeln pflegen zu muessen.
class ProductCatalog {
  ProductCatalog._();

  /// Fellbuerste je nach Pflegebedarf + Felltyp der Rasse.
  static ProductRecommendation brushFor(DogBreed breed) {
    final coat = (breed.coatType ?? '').toLowerCase();
    final highGrooming = breed.grooming >= 4 || breed.shedding >= 4;

    if (coat.contains('lock') || coat.contains('curl')) {
      return const ProductRecommendation(
        kind: ProductKind.brush,
        title: 'Zupfbuerste fuer Lockenfell',
        subtitle: 'Loest Knoten bei Pudel & Co. schonend',
        priceHintEur: 'ca. 12-18 EUR',
        imageUrl:
            'https://images.unsplash.com/photo-1591768575198-88dac53fbd0a?w=400&q=70',
        shopUrl: 'https://www.amazon.de/s?k=zupfb%C3%BCrste+hund+lockenfell',
      );
    }
    if (highGrooming || coat.contains('lang') || coat.contains('stock')) {
      return const ProductRecommendation(
        kind: ProductKind.brush,
        title: 'Unterwoll-Harke (Deshedder)',
        subtitle: 'Ideal bei dichtem Fell & Fellwechsel',
        priceHintEur: 'ca. 15-25 EUR',
        imageUrl:
            'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&q=70',
        shopUrl: 'https://www.amazon.de/s?k=unterwolle+b%C3%BCrste+hund',
      );
    }
    return const ProductRecommendation(
      kind: ProductKind.brush,
      title: 'Gummi-Striegel fuer Kurzhaar',
      subtitle: 'Massiert und entfernt lose Haare',
      priceHintEur: 'ca. 8-14 EUR',
      imageUrl:
          'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=400&q=70',
      shopUrl: 'https://www.amazon.de/s?k=gummistriegel+hund+kurzhaar',
    );
  }

  /// Futter-Empfehlung je nach Groesse + Aktivitaet der Rasse.
  static ProductRecommendation foodFor(DogBreed breed) {
    final size = breed.size.name;
    final active = breed.exerciseNeed >= 4;

    if (size == 'large' || size == 'giant') {
      return ProductRecommendation(
        kind: ProductKind.food,
        title: active
            ? 'Trockenfutter Large Breed Aktiv'
            : 'Trockenfutter Large Breed',
        subtitle: 'Grosse Kroketten, Gelenk-Support (Glucosamin)',
        priceHintEur: 'ca. 45-60 EUR / 12 kg',
        imageUrl:
            'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=400&q=70',
        shopUrl: 'https://www.amazon.de/s?k=hundefutter+large+breed',
      );
    }
    if (size == 'small' || size == 'toy') {
      return const ProductRecommendation(
        kind: ProductKind.food,
        title: 'Trockenfutter Small Breed',
        subtitle: 'Kleine Kroketten, hoher Energiegehalt',
        priceHintEur: 'ca. 18-28 EUR / 3 kg',
        imageUrl:
            'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=400&q=70',
        shopUrl: 'https://www.amazon.de/s?k=hundefutter+small+breed',
      );
    }
    return ProductRecommendation(
      kind: ProductKind.food,
      title: active ? 'Trockenfutter Adult Aktiv' : 'Trockenfutter Adult',
      subtitle: active
          ? 'Erhoehter Proteingehalt fuer aktive Hunde'
          : 'Ausgewogen fuer normalen Aktivitaetslevel',
      priceHintEur: 'ca. 30-42 EUR / 12 kg',
      imageUrl:
          'https://images.unsplash.com/photo-1582798358481-d199fb7347bb?w=400&q=70',
      shopUrl: 'https://www.amazon.de/s?k=hundefutter+adult',
    );
  }

  /// Kurzer Futter-Steckbrief: was diese Rasse braucht (Eigenschaften).
  static String foodProfile(DogBreed breed) {
    final parts = <String>[];
    if (breed.exerciseNeed >= 4) {
      parts.add('hoher Energiebedarf - proteinreiches Futter');
    } else if (breed.exerciseNeed <= 2) {
      parts.add('ruhiger - auf Portionsgroesse achten (Uebergewicht vermeiden)');
    } else {
      parts.add('normaler Energiebedarf - ausgewogenes Adult-Futter');
    }
    if (breed.size.name == 'large' || breed.size.name == 'giant') {
      parts.add('grosse Rasse - Gelenk-Support sinnvoll');
    }
    if (breed.size.name == 'small' || breed.size.name == 'toy') {
      parts.add('kleine Rasse - kleine Kroketten, mehrere Portionen/Tag');
    }
    return parts.join(' · ');
  }
}
