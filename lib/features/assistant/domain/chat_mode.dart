/// Modus des KI-Beraters. Wechselt System-Prompt und Begruessungstext.
enum ChatMode {
  advisor('Berater', 'Rassen, Haltung, Pflege, Anschaffung'),
  trainer('Trainer', 'Verhalten, Erziehung, Trainings-Uebungen');

  const ChatMode(this.label, this.shortDescription);

  final String label;
  final String shortDescription;
}
