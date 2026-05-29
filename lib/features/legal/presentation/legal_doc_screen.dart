import 'package:dogmatch_ai/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum LegalDoc { imprint, privacy, terms, disclaimer }

/// Generischer Anzeige-Screen fuer einen rechtlichen Text.
/// Inhalte sind Mustervorlagen - bitte vor Live-Betrieb anpassen!
class LegalDocScreen extends StatelessWidget {
  const LegalDocScreen({super.key, required this.doc});

  final LegalDoc doc;

  String get _title {
    switch (doc) {
      case LegalDoc.imprint:
        return 'Impressum';
      case LegalDoc.privacy:
        return 'Datenschutzerklaerung';
      case LegalDoc.terms:
        return 'Nutzungsbedingungen';
      case LegalDoc.disclaimer:
        return 'Haftungsausschluss';
    }
  }

  String get _body {
    switch (doc) {
      case LegalDoc.imprint:
        return _imprintText;
      case LegalDoc.privacy:
        return _privacyText;
      case LegalDoc.terms:
        return _termsText;
      case LegalDoc.disclaimer:
        return _disclaimerText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              'Mustervorlage. Vor Veroeffentlichung bitte mit Anwalt '
              'pruefen + auf deine Daten anpassen.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SelectableText(
            _body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---- Inhalte ----

const _imprintText = '''
Anbieter dieser App (Mustervorlage - bitte anpassen):

[Vor- und Nachname / Firmenname]
[Strasse + Hausnummer]
[PLZ + Ort]
[Land]

Kontakt
E-Mail:    [deine@email.de]
Telefon:   [+49 ...]

Vertretungsberechtigt:
[Name der vertretungsberechtigten Person]

Verantwortlich fuer den Inhalt nach Paragraph 55 Abs. 2 RStV:
[Name + Anschrift wie oben]

Umsatzsteuer-Identifikationsnummer (sofern vorhanden):
[USt-IdNr.]

EU-Streitschlichtung:
Die Europaeische Kommission stellt eine Plattform zur Online-Streit-
beilegung bereit: https://ec.europa.eu/consumers/odr/

Verbraucherstreitbeilegung / Universalschlichtungsstelle:
Wir sind nicht bereit oder verpflichtet, an einem Streitbeilegungs-
verfahren teilzunehmen.
''';

const _privacyText = '''
Datenschutzerklaerung (Mustervorlage)

1. Verantwortlicher
Verantwortlich fuer die Verarbeitung deiner Daten ist:
[Vor- und Nachname / Firma]
[Anschrift wie im Impressum]
E-Mail: [deine@email.de]

2. Welche Daten verarbeitet werden

Local Storage / lokale Daten
DogMatch AI speichert FREIWILLIG gemachte Angaben (Hundeprofile,
Termine, Dokumente, Trainings-Fortschritt, KI-Chats) ausschliesslich
im lokalen Speicher deines Geraets oder Browsers. Es findet keine
Synchronisation auf unsere Server statt.

Firebase Authentication (nur wenn du dich anmeldest)
Falls du dich anmeldest, speichert Firebase deine E-Mail-Adresse und
einen Login-Token. Anbieter: Google Ireland Limited, Gordon House,
Barrow Street, Dublin 4, Irland. Datenschutz-Information:
https://policies.google.com/privacy

Firebase Firestore (nur wenn angemeldet)
Wenn du angemeldet bist und Cloud-Synchronisation aktivierst, werden
Hundeprofile, Termine und Dokumente in der Firestore-Datenbank von
Google in EU-Rechenzentren gespeichert. Loeschung ueber Profil.

KI-Berater
Beim Nutzen des KI-Beraters wird deine Frage an einen Drittanbieter
(Pollinations.ai oder dein eigener Worker) gesendet. Inhalt der
Frage + Antwort liegt vor der Uebertragung ausschliesslich auf deinem
Geraet. Die Anfrage selbst wird nicht von uns gespeichert.

GitHub Pages
Die App wird ueber GitHub Pages ausgeliefert. Anbieter: GitHub, Inc.,
88 Colin P Kelly Jr St, San Francisco, CA 94107, USA. GitHub kann
beim Aufruf Server-Log-Daten verarbeiten:
https://docs.github.com/site-policy/privacy-policies/github-privacy-statement

3. Cookies / lokale Speicher-Mechanismen
Wir verwenden keine Tracking-Cookies. Lokal speichern wir nur, was
du selbst eintraegst.

4. Deine Rechte (DSGVO Art. 15-22)
Auskunft, Berichtigung, Loeschung, Einschraenkung, Datenuebertrag-
barkeit und Widerspruch. Beschwerde bei einer Aufsichtsbehoerde
moeglich.

5. Kontakt
Anfragen zum Datenschutz an: [deine@email.de]

Stand: [Datum eintragen]
''';

const _termsText = '''
Nutzungsbedingungen (Mustervorlage)

1. Geltungsbereich
Diese Bedingungen regeln die Nutzung der App DogMatch AI durch den
Endnutzer.

2. Zweck der App
DogMatch AI bietet Informationen, Tipps, Checklisten und KI-basierte
Hilfestellung rund um die Hundehaltung. Die App ersetzt KEINEN
Tierarzt, KEINEN Trainer und KEINE Rechtsberatung.

3. Nutzerprofil
Du bist verpflichtet, korrekte Angaben in deinem Profil zu machen
und deine Zugangsdaten vor Missbrauch zu schuetzen.

4. KI-Inhalte
Antworten des KI-Beraters werden automatisch von einem
Sprachmodell erzeugt. Wir uebernehmen keine Garantie fuer Richtig-
keit, Vollstaendigkeit oder Aktualitaet. Inhalte koennen Fehler
enthalten. In medizinischen Fragen IMMER einen Tierarzt konsultieren.

5. Verbotene Nutzung
Untersagt sind unter anderem: Veroeffentlichung von Inhalten, die
Tierschutzgesetze verletzen, gewerbliche Nutzung ohne Erlaubnis,
Umgehung technischer Sicherungen, Reverse Engineering.

6. Beendigung
Du kannst die App jederzeit beenden, indem du sie loeschst oder
dein Konto kuendigst. Wir behalten uns vor, Konten bei Verstoss
gegen diese Bedingungen zu sperren.

7. Aenderungen
Wir behalten uns vor, diese Bedingungen anzupassen. Wesentliche
Aenderungen werden in der App angekuendigt.

8. Anwendbares Recht
Es gilt deutsches Recht. Gerichtsstand fuer Vollkaufleute: [Ort].

Stand: [Datum eintragen]
''';

const _disclaimerText = '''
Haftungsausschluss

Die App DogMatch AI bietet allgemeine Informationen rund um Hunde.
Sie ist KEIN Ersatz fuer:

- den Besuch beim Tierarzt
- die Beratung durch einen zertifizierten Hundetrainer
- eine rechtliche Beratung (z. B. zu Listenhund-Verordnungen)
- die Pflege und Aufsicht durch einen verantwortlichen Halter

KI-Antworten
Die Antworten des KI-Beraters werden von Sprachmodellen automatisch
generiert. Sie koennen Fehler, veraltete Informationen oder ungenaue
Empfehlungen enthalten. Wir uebernehmen KEINE Garantie fuer Richtig-
keit und Vollstaendigkeit.

Symptom- und Verhalten-Check
Die Auswertung ist eine grobe Einschaetzung auf Basis fester Regeln.
Sie ersetzt keine tieraerztliche Diagnose. Bei Notfaellen (Erbrechen
mit Blut, Atemnot, Aggression, schwere Verletzungen): sofort zum
Tierarzt oder zur Tierklinik.

Trainings-Anleitungen
Die Trainings-Plaene basieren auf positiver Bestaerkung. Jedes Tier
ist individuell. Bei aggressivem Verhalten oder Verhaltensstoerungen
unbedingt einen erfahrenen, zertifizierten Trainer hinzuziehen.

Externe Links + Videos
Bei Verlinkungen auf externe Plattformen (z. B. YouTube) uebernehmen
wir keine Verantwortung fuer die Inhalte der verlinkten Seiten.

Haftungsbeschraenkung
Wir haften nur fuer Schaeden, die auf vorsaetzliches oder grob
fahrlaessiges Verhalten unsererseits zurueckzufuehren sind, sowie fuer
Verletzungen von Leben, Koerper oder Gesundheit.

Stand: [Datum eintragen]
''';
