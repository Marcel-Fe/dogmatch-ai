import 'package:dogmatch_ai/core/enums/country.dart';
import 'package:dogmatch_ai/features/breeds/domain/breed_enums.dart';
import 'package:equatable/equatable.dart';

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
    bool clearPreferredSize = false,
    bool clearPreferredActivity = false,
  }) {
    return UserPreferences(
      displayName: displayName ?? this.displayName,
      country: country ?? this.country,
      preferredSize:
          clearPreferredSize ? null : (preferredSize ?? this.preferredSize),
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
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final sizeName = json['preferredSize'] as String?;
    final activityName = json['preferredActivity'] as String?;
    return UserPreferences(
      displayName: json['displayName'] as String?,
      country: Country.fromCode(json['country'] as String?),
      preferredSize:
          sizeName == null ? null : DogSize.values.byName(sizeName),
      preferredActivity: activityName == null
          ? null
          : ActivityLevel.values.byName(activityName),
      ttsEnabled: (json['ttsEnabled'] as bool?) ?? true,
      showUpcomingOnHome: (json['showUpcomingOnHome'] as bool?) ?? true,
      showForYouOnHome: (json['showForYouOnHome'] as bool?) ?? true,
      showFeatureGridOnHome:
          (json['showFeatureGridOnHome'] as bool?) ?? true,
      showAllBreedsOnHome: (json['showAllBreedsOnHome'] as bool?) ?? true,
      seniorMode: (json['seniorMode'] as bool?) ?? false,
    );
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
      ];
}
