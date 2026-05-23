/// Zentrale Routen-Definitionen. Pfade an einer Stelle - so bleibt die
/// Navigation tippfehlerfrei und leicht aenderbar.
class AppRoutes {
  AppRoutes._();

  // Vollbild-Einstieg
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';

  // Haupt-Tabs (innerhalb der Bottom-Navigation)
  static const String home = '/home';
  static const String quiz = '/quiz';
  static const String assistant = '/assistant';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Vollbild-Detailseiten
  static const String breedDetail = '/breed'; // /breed/:id
  static const String matchResults = '/matches';
  static const String knowledge = '/knowledge';
  static const String article = '/article'; // /article/:id
  static const String premium = '/premium';
  static const String settings = '/settings';
  static const String breederFinder = '/breeders';
  static const String breederProfile = '/breeder'; // /breeder/:id
}
