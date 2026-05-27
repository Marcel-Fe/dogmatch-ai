import 'package:equatable/equatable.dart';

/// Kategorie eines Symptoms (fuer UI-Gruppierung).
enum SymptomCategory {
  digestion('Verdauung'),
  energy('Energie & Verhalten'),
  skin('Haut & Fell'),
  breathing('Atmung'),
  movement('Bewegung'),
  appetite('Appetit'),
  other('Sonstiges');

  const SymptomCategory(this.label);
  final String label;
}

class Symptom extends Equatable {
  const Symptom({
    required this.id,
    required this.label,
    required this.category,
  });

  final String id;
  final String label;
  final SymptomCategory category;

  @override
  List<Object?> get props => [id, label, category];
}

/// Empfehlung nach Pruefung. Vor allem: wie dringend?
enum Urgency {
  routine('Beobachten', 'In den naechsten Tagen beobachten'),
  visit('Tierarzt-Termin', 'In den naechsten 1-2 Tagen Tierarzt aufsuchen'),
  urgent('Heute zum Tierarzt', 'Noch heute den Tierarzt kontaktieren'),
  emergency('SOFORT Notfall-Tierarzt', 'Sofort den Notdienst anrufen oder hinfahren');

  const Urgency(this.label, this.advice);
  final String label;
  final String advice;
}

class Diagnosis extends Equatable {
  const Diagnosis({
    required this.title,
    required this.urgency,
    required this.description,
    this.recommendation = '',
  });

  final String title;
  final Urgency urgency;
  final String description;
  final String recommendation;

  @override
  List<Object?> get props => [title, urgency, description, recommendation];
}
