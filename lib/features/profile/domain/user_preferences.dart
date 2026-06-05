import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Auswaehlbare Dashboard-Designs (Akzentfarbe + Stimmung). Beeinflusst die
/// Toenung der ganzen App. Hundethematische, moderne Varianten zur Wahl.
/// Die Enum-IDs (violet, ocean, ...) bleiben stabil, damit gespeicherte
/// Einstellungen weiter passen - nur Label/Farben sind hundethematisch.
enum DashboardStyle {
  violet('Lavendel', Color(0xFF7C6BF0)),
  ocean('Husky', Color(0xFF2E8BC0)),
  forest('Border Collie', Color(0xFF1F8A70)),
  sunset('Sonnenuntergang', Color(0xFFEF6C45)),
  graphite('Dobermann', Color(0xFF4A5A66)),
  golden('Golden Retriever', Color(0xFFE0A02E)),
  chocolate('Labrador', Color(0xFF7B4B2A)),
  rose('Samojede', Color(0xFFE5739A)),
  copper('Beagle', Color(0xFFC4622D)),
  berry('Beere', Color(0xFFAD3777)),
  sky('Weimaraner', Color(0xFF5C7C99)),
  midnight('Mitternacht', Color(0xFF3D5AFE));

  const DashboardStyle(this.label, this.seed);

  final String label;
  final Color seed;
}

/// Auswaehlbare Dashboard-Layouts (Anordnung & Look der Startseite). Anders
/// als [DashboardStyle] (nur Farbe) aendert das Layout, welche Bereiche in
/// welcher Reihenfolge und Dichte erscheinen. IDs bleiben stabil.
enum DashboardLayout {
  standard(
    'Standard',
    'Die klassische, vollstaendige Startseite mit allen Bereichen.',
    Icons.dashboard_rounded,
  ),
  focus(
    'Fokus',
    'Aufgeraeumt: nur das Wichtigste fuer heute - Hund, KI und Termine.',
    Icons.center_focus_strong_rounded,
  ),
  compact(
    'Kompakt',
    'Dichte Uebersicht mit Schnellaktionen ganz oben - alles auf einen Blick.',
    Icons.view_agenda_rounded,
  ),
  magazine(
    'Magazin',
    'Bildstark: Rassen und Entdeckungen mit grossen Karten zuerst.',
    Icons.auto_awesome_mosaic_rounded,
  );

  const DashboardLayout(this.label, this.description, this.icon);

  final String label;
  final String description;
  final IconData icon;
}

/// Auswaehlbare Hintergruende der Startseite. Kombiniert mit dem Seed des
/// [DashboardStyle] faerbt sich der Dashboard-Hintergrund mit dem Design mit.
/// Bewusst leichtgewichtig (kein Vollbild-Blur). IDs bleiben stabil.
enum DashboardBackground {
  plain(
    'Schlicht',
    'Ruhiger, neutraler Hintergrund ohne Toenung.',
    Icons.crop_din_rounded,
  ),
  gradient(
    'Verlauf',
    'Weicher Farbverlauf in deiner Designfarbe.',
    Icons.gradient_rounded,
  ),
  mesh(
    'Farbflaechen',
    'Weiche Farbkreise fuer einen modernen Look.',
    Icons.blur_on_rounded,
  ),
  paws(
    'Pfoten',
    'Dezentes Pfoten-Muster in deiner Designfarbe.',
    Icons.pets_rounded,
  );

  const DashboardBackground(this.label, this.description, this.icon);

  final String label;
  final String description;
  final IconData icon;
}

/// Personalisierungs-Einstellungen des Nutzers. Lokal persistiert
/// (`shared_preferences`); spaeter optional in Firestore synchronisiert.
class UserPreferences extends Equatable {
  const UserPreferences({
    this.displayName,
    this.country = Country.germany,
    this.preferredSize,
    this.preferredActivity,
    this.ttsEnabled = true,
    this.showUpcomingOnHome = true,
    this.showForYouOnHome = true,
    this.showFeatureGridOnHome = true,
    this.showAllBreedsOnHome = true,
    this.seniorMode = false,
    this.dashboardStyle = DashboardStyle.violet,
    this.dashboardLayout = DashboardLayout.standard,
    this.dashboardBackground = DashboardBackground.gradient,
  });

  /// Anzeigename - wird in der Begruessung auf Home verwendet.
  final String? displayName;

  /// Wohnsitzland - bestimmt, welche Laender-Hinweise im Rassenprofil
  /// hervorgehoben werden.
  final Country country;

  /// Bevorzugte Hundegroesse - kann das Matching-Quiz vorausfuellen.
  final DogSize? preferredSize;

  /// Bevorzugtes Aktivitaetsniveau.
  final ActivityLevel? preferredActivity;

  /// Sprachausgabe des KI-Beraters (Web Speech API).
  final bool ttsEnabled;

  /// Welche Dashboard-Sektionen aktiv sind. Nutzer kann das in
  /// Einstellungen steuern.
  final bool showUpcomingOnHome;
  final bool showForYouOnHome;
  final bool showFeatureGridOnHome;
  final bool showAllBreedsOnHome;

  /// Senioren-Modus: groessere Schrift + hoehere Kontraste in der ganzen App.
  final bool seniorMode;

  /// Gewaehltes Dashboard-Design (Akzentfarbe der App).
  final DashboardStyle dashboardStyle;

  /// Gewaehltes Dashboard-Layout (Anordnung der Startseite).
  final DashboardLayout dashboardLayout;

  /// Gewaehlter Dashboard-Hintergrund (Toenung/Muster der Startseite).
  final DashboardBackground dashboardBackground;

  bool get hasName => displayName != null && displayName!.trim().isNotEmpty;

  UserPreferences copyWith({
    String? displayName,
    Country? country,
    DogSize? preferredSize,
    ActivityLevel? preferredActivity,
    bool? ttsEnabled,
    bool? showUpcomingOnHome,
    bool? showForYouOnHome,
    bool? showFeatureGridOnHome,
    bool? showAllBreedsOnHome,
    bool? seniorMode,
    DashboardStyle? dashboardStyle,
    DashboardLayout? dashboardLayout,
    DashboardBackground? dashboardBackground,
    bool clearPreferredSize = false,
    bool clearPreferredActivity = false,
  }) {
    return UserPreferences(
      displayName: displayName ?? this.displayName,
      country: country ?? this.country,
      preferredSize: clearPreferredSize
          ? null
          : (preferredSize ?? this.preferredSize),
      preferredActivity: clearPreferredActivity
          ? null
          : (preferredActivity ?? this.preferredActivity),
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      showUpcomingOnHome: showUpcomingOnHome ?? this.showUpcomingOnHome,
      showForYouOnHome: showForYouOnHome ?? this.showForYouOnHome,
      showFeatureGridOnHome:
          showFeatureGridOnHome ?? this.showFeatureGridOnHome,
      showAllBreedsOnHome: showAllBreedsOnHome ?? this.showAllBreedsOnHome,
      seniorMode: seniorMode ?? this.seniorMode,
      dashboardStyle: dashboardStyle ?? this.dashboardStyle,
      dashboardLayout: dashboardLayout ?? this.dashboardLayout,
      dashboardBackground: dashboardBackground ?? this.dashboardBackground,
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final sizeName = json['preferredSize'] as String?;
    final activityName = json['preferredActivity'] as String?;
    return UserPreferences(
      displayName: json['displayName'] as String?,
      country: Country.fromCode(json['country'] as String?),
      preferredSize: sizeName == null ? null : DogSize.values.byName(sizeName),
      preferredActivity: activityName == null
          ? null
          : ActivityLevel.values.byName(activityName),
      ttsEnabled: (json['ttsEnabled'] as bool?) ?? true,
      showUpcomingOnHome: (json['showUpcomingOnHome'] as bool?) ?? true,
      showForYouOnHome: (json['showForYouOnHome'] as bool?) ?? true,
      showFeatureGridOnHome: (json['showFeatureGridOnHome'] as bool?) ?? true,
      showAllBreedsOnHome: (json['showAllBreedsOnHome'] as bool?) ?? true,
      seniorMode: (json['seniorMode'] as bool?) ?? false,
      dashboardStyle: _parseStyle(json['dashboardStyle'] as String?),
      dashboardLayout: _parseLayout(json['dashboardLayout'] as String?),
      dashboardBackground: _parseBackground(
        json['dashboardBackground'] as String?,
      ),
    );
  }

  static DashboardStyle _parseStyle(String? name) {
    if (name == null) return DashboardStyle.violet;
    for (final s in DashboardStyle.values) {
      if (s.name == name) return s;
    }
    return DashboardStyle.violet;
  }

  static DashboardLayout _parseLayout(String? name) {
    if (name == null) return DashboardLayout.standard;
    for (final l in DashboardLayout.values) {
      if (l.name == name) return l;
    }
    return DashboardLayout.standard;
  }

  static DashboardBackground _parseBackground(String? name) {
    if (name == null) return DashboardBackground.gradient;
    for (final b in DashboardBackground.values) {
      if (b.name == name) return b;
    }
    return DashboardBackground.gradient;
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'country': country.code,
      'preferredSize': preferredSize?.name,
      'preferredActivity': preferredActivity?.name,
      'ttsEnabled': ttsEnabled,
      'showUpcomingOnHome': showUpcomingOnHome,
      'showForYouOnHome': showForYouOnHome,
      'showFeatureGridOnHome': showFeatureGridOnHome,
      'showAllBreedsOnHome': showAllBreedsOnHome,
      'seniorMode': seniorMode,
      'dashboardStyle': dashboardStyle.name,
      'dashboardLayout': dashboardLayout.name,
      'dashboardBackground': dashboardBackground.name,
    };
  }

  @override
  List<Object?> get props => [
    displayName,
    country,
    preferredSize,
    preferredActivity,
    ttsEnabled,
    showUpcomingOnHome,
    showForYouOnHome,
    showFeatureGridOnHome,
    showAllBreedsOnHome,
    seniorMode,
    dashboardStyle,
    dashboardLayout,
    dashboardBackground,
  ];
}
