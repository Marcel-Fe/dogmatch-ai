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
  static const String breedList = '/breeds-all';
  static const String mixBreed = '/mix-breed';
  static const String breedDetail = '/breed'; // /breed/:id
  static const String matchResults = '/matches';
  static const String knowledge = '/knowledge';
  static const String article = '/article'; // /article/:id
  static const String premium = '/premium';
  static const String settings = '/settings';
  static const String breederFinder = '/breeders';
  static const String breederProfile = '/breeder'; // /breeder/:id
  static const String editProfile = '/edit-profile';

  // Hunde-Verwaltung
  static const String dogRecord = '/dog-record';
  static const String manageDogs = '/dogs';
  static const String addDog = '/dogs/add';
  static const String editDog = '/dogs/edit'; // /dogs/edit/:id

  // Gesundheitskalender + Dokumente
  static const String healthCalendar = '/health';
  static const String addHealthEvent = '/health/add';
  static const String documents = '/documents';

  // Training
  static const String training = '/training';
  static const String trainingDetail = '/training'; // /training/:id

  // Symptom-Check
  static const String symptomCheck = '/symptom-check';

  // Umgebung (Tieraerzte, Kliniken, Kotbeutel in der Naehe)
  static const String nearby = '/nearby';

  // Verhalten-Check
  static const String behaviorCheck = '/behavior-check';

  // Wissen / Tipps
  static const String tips = '/tips';

  // Checklisten
  static const String checklists = '/checklists';
  static const String checklistDetail = '/checklists'; // /checklists/:id

  // Urlaub
  static const String vacation = '/vacation';

  // Rechtliches
  static const String legal = '/legal';
  static const String imprint = '/legal/imprint';
  static const String privacy = '/legal/privacy';
  static const String terms = '/legal/terms';
  static const String disclaimer = '/legal/disclaimer';
}
