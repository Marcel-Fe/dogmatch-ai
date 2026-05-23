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

  bool get hasName => displayName != null && displayName!.trim().isNotEmpty;

  UserPreferences copyWith({
    String? displayName,
    Country? country,
    DogSize? preferredSize,
    ActivityLevel? preferredActivity,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'country': country.code,
      'preferredSize': preferredSize?.name,
      'preferredActivity': preferredActivity?.name,
    };
  }

  @override
  List<Object?> get props =>
      [displayName, country, preferredSize, preferredActivity];
}
