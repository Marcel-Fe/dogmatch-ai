/// Stub fuer Plattformen ohne Web Share API.
Future<bool> shareApp({
  String title = 'DogMatch AI',
  String text = 'Schau dir DogMatch AI an!',
  String url = '',
}) async =>
    false;

Future<bool> copyToClipboard(String text) async => false;
