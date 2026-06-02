import 'package:dogmatch_ai/features/treats/domain/treat_recipe.dart';

/// Kuratierte, hundesichere Leckerli-Rezepte. Bewusst ohne Zucker, Salz,
/// Schokolade, Xylit, Zwiebel, Trauben/Rosinen - alles, was fuer Hunde
/// giftig ist, kommt nicht vor.
class TreatRecipesCatalog {
  TreatRecipesCatalog._();

  static const List<TreatRecipe> all = [
    // ---- Gebacken ----
    TreatRecipe(
      id: 't1',
      category: TreatCategory.baked,
      title: 'Bananen-Hafer-Kekse',
      subtitle: '3 Zutaten, schnell gemacht',
      ingredients: [
        '1 reife Banane',
        '150 g Haferflocken',
        '1 Ei',
      ],
      steps: [
        'Backofen auf 180 Grad C vorheizen.',
        'Banane zerdruecken, mit Haferflocken und Ei verkneten.',
        'Kleine Taler formen, auf Backblech mit Backpapier setzen.',
        '15-18 Minuten backen, bis sie fest sind. Auskuehlen lassen.',
      ],
      storage: 'In einer Dose ca. 1 Woche, eingefroren laenger.',
      tip: 'Fuer kleine Hunde die Taler besonders duenn ausrollen.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Oatmeal-Cookie.jpg/960px-Oatmeal-Cookie.jpg',
    ),
    TreatRecipe(
      id: 't2',
      category: TreatCategory.baked,
      title: 'Thunfisch-Wuerfel',
      subtitle: 'Herzhaft und sehr beliebt',
      ingredients: [
        '1 Dose Thunfisch im eigenen Saft (ohne Salz/Oel abgegossen)',
        '1 Ei',
        '4-5 EL Haferflocken oder Reismehl',
      ],
      steps: [
        'Backofen auf 175 Grad C vorheizen.',
        'Alles zu einer Masse verruehren.',
        'Duenn auf ein Backblech streichen.',
        '15 Minuten backen, abkuehlen, in kleine Wuerfel schneiden.',
      ],
      storage: 'Im Kuehlschrank 3-4 Tage, einfrieren moeglich.',
      tip: 'Perfekt als hochwertiges Trainings-Leckerli.',
    ),
    TreatRecipe(
      id: 't3',
      category: TreatCategory.baked,
      title: 'Kuerbis-Kekse',
      subtitle: 'Gut fuer die Verdauung',
      ingredients: [
        '150 g Kuerbispuree (ungesuesst, ohne Gewuerze)',
        '200 g Vollkornmehl oder Haferflocken',
        '1 Ei',
      ],
      steps: [
        'Backofen auf 180 Grad C vorheizen.',
        'Zutaten zu einem Teig verkneten, ggf. etwas Mehl ergaenzen.',
        'Ausrollen und Formen ausstechen.',
        '20 Minuten backen, bis sie knusprig sind.',
      ],
      storage: 'Trocken gelagert 1-2 Wochen.',
    ),
    TreatRecipe(
      id: 't4',
      category: TreatCategory.baked,
      title: 'Karotten-Apfel-Taler',
      subtitle: 'Vitaminreich',
      ingredients: [
        '1 geraspelte Karotte',
        '1/2 geraspelter Apfel (ohne Kerngehaeuse)',
        '150 g Haferflocken',
        '1 Ei',
      ],
      steps: [
        'Backofen auf 180 Grad C vorheizen.',
        'Alles vermengen, kleine Taler formen.',
        '18-20 Minuten backen, auskuehlen lassen.',
      ],
      storage: 'In einer Dose ca. 1 Woche.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Grated_carrot_2.jpg/960px-Grated_carrot_2.jpg',
    ),

    // ---- Ohne Backen ----
    TreatRecipe(
      id: 't5',
      category: TreatCategory.noBake,
      title: 'Quark-Kraeuter-Baellchen',
      subtitle: 'In 5 Minuten fertig',
      ingredients: [
        '3 EL Magerquark',
        'frische Petersilie, fein gehackt',
        'Haferflocken zum Binden',
      ],
      steps: [
        'Quark mit Petersilie verruehren.',
        'So viele Haferflocken einkneten, bis eine formbare Masse entsteht.',
        'Kleine Baellchen rollen.',
      ],
      storage: 'Im Kuehlschrank 2-3 Tage.',
      tip: 'Petersilie hilft sogar gegen Mundgeruch.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Berry_quark_and_coffee_at_restaurant_Sapusca.jpg/960px-Berry_quark_and_coffee_at_restaurant_Sapusca.jpg',
    ),
    TreatRecipe(
      id: 't6',
      category: TreatCategory.noBake,
      title: 'Erdnussbutter-Happen',
      subtitle: 'Nur 2 Zutaten',
      ingredients: [
        '2 EL Erdnussbutter (OHNE Xylit/Suessstoff, ungesalzen)',
        'Haferflocken',
      ],
      steps: [
        'Erdnussbutter mit so vielen Haferflocken verkneten, bis es formbar ist.',
        'Kleine Kugeln rollen und kurz kalt stellen.',
      ],
      storage: 'Im Kuehlschrank ca. 4 Tage.',
      tip: 'WICHTIG: Erdnussbutter MUSS xylitfrei sein - Xylit ist giftig.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Three_lb_peanut_butter_jar.jpg/960px-Three_lb_peanut_butter_jar.jpg',
    ),

    // ---- Gefroren ----
    TreatRecipe(
      id: 't7',
      category: TreatCategory.frozen,
      title: 'Joghurt-Beeren-Eis',
      subtitle: 'Erfrischung fuer heisse Tage',
      ingredients: [
        'Naturjoghurt (ohne Zucker)',
        'einige Heidelbeeren oder Himbeeren',
      ],
      steps: [
        'Joghurt mit den Beeren verruehren.',
        'In eine Eiswuerfelform oder Silikonform fuellen.',
        'Ueber Nacht einfrieren.',
      ],
      storage: 'Im Gefrierfach mehrere Wochen.',
      tip: 'Nur kleine Portionen geben - kalt und langsam schlecken lassen.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Berry_Frozen_Yogurt_%284723048814%29.jpg/960px-Berry_Frozen_Yogurt_%284723048814%29.jpg',
    ),
    TreatRecipe(
      id: 't8',
      category: TreatCategory.frozen,
      title: 'Brueh-Eis',
      subtitle: 'Herzhaft und fluessigkeitsspendend',
      ingredients: [
        'ungesalzene Gemuese- oder Huehnerbruehe (selbst gekocht, ohne Zwiebel)',
      ],
      steps: [
        'Bruehe abkuehlen lassen.',
        'In Eiswuerfelformen fuellen und einfrieren.',
      ],
      storage: 'Im Gefrierfach mehrere Wochen.',
      tip: 'Niemals Fertigbruehe mit Salz/Zwiebel verwenden.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c3/Ice_cube_tray.jpg',
    ),
    TreatRecipe(
      id: 't9',
      category: TreatCategory.frozen,
      title: 'Gefuellter Kong (gefroren)',
      subtitle: 'Lange Beschaeftigung',
      ingredients: [
        'etwas Magerquark oder Naturjoghurt',
        'ein paar Haferflocken + Banane',
      ],
      steps: [
        'Kong-Spielzeug mit der Masse fuellen.',
        'Ueber Nacht einfrieren.',
        'An heissen Tagen oder bei Langeweile geben.',
      ],
      storage: 'Einzeln eingefroren mehrere Wochen.',
      tip: 'Haelt aufgeregte Hunde lange und ruhig beschaeftigt.',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Dog_with_rawhide_chew_toy.jpg/960px-Dog_with_rawhide_chew_toy.jpg',
    ),

    // ---- Trainings-Snack ----
    TreatRecipe(
      id: 't10',
      category: TreatCategory.training,
      title: 'Leber-Wuerfel',
      subtitle: 'Das Highlight im Training',
      ingredients: [
        '250 g Rinderleber',
        '1 Ei',
        '3-4 EL Haferflocken',
      ],
      steps: [
        'Leber puerieren, mit Ei und Haferflocken vermengen.',
        'Duenn auf ein Backblech streichen.',
        'Bei 170 Grad C ca. 20 Minuten backen.',
        'Auskuehlen, in winzige Wuerfel schneiden.',
      ],
      storage: 'Im Kuehlschrank 3 Tage, sonst portionsweise einfrieren.',
      tip: 'Sehr intensiv - nur kleine Mengen, sonst Durchfall.',
    ),
    TreatRecipe(
      id: 't11',
      category: TreatCategory.training,
      title: 'Kaese-Tropfen',
      subtitle: 'Mini-Belohnung',
      ingredients: [
        'fettarmer Kaese (z.B. Huettenkaese oder magerer Gouda)',
      ],
      steps: [
        'Kaese in sehr kleine Wuerfel schneiden.',
        'Sparsam als Highlight im Training einsetzen.',
      ],
      storage: 'Im Kuehlschrank wie normaler Kaese.',
      tip: 'Nur kleine Mengen - Kaese ist fett- und kalorienreich.',
    ),
    TreatRecipe(
      id: 't12',
      category: TreatCategory.training,
      title: 'Trockenfleisch-Streifen',
      subtitle: 'Kauspass ohne Zusaetze',
      ingredients: [
        'mageres Rind- oder Huehnerfleisch in duennen Streifen',
      ],
      steps: [
        'Fleisch in duenne Streifen schneiden.',
        'Im Backofen bei 70-80 Grad C mehrere Stunden trocknen (Tuer einen Spalt offen).',
        'Fertig, wenn die Streifen ledrig-trocken sind.',
      ],
      storage: 'Vollstaendig getrocknet 2-3 Wochen trocken gelagert.',
      tip: 'Komplett durchtrocknen, sonst schimmelt es.',
    ),
  ];

  static List<TreatRecipe> byCategory(TreatCategory? cat) {
    if (cat == null) return all;
    return all.where((r) => r.category == cat).toList(growable: false);
  }
}
