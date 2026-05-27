# Firebase Storage aktivieren (Gap B)

Der Dokumente-Bereich der App speichert Datei-Bytes in Firebase Storage.
Code ist fertig, aber Storage muss in der Firebase-Console einmalig
freigeschaltet werden.

## 1. Storage einschalten

1. https://console.firebase.google.com/project/dogmatch-ai/storage oeffnen.
2. "Erste Schritte" klicken.
3. **Region**: `europe-west3` waehlen (Frankfurt, DSGVO-freundlich).
4. **Sicherheitsregeln-Modus**: erstmal "Produktion" (geschlossen).

## 2. Rules anpassen

Nach der Aktivierung im Tab **Regeln** folgende Regeln einsetzen:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null
                        && request.auth.uid == userId;
    }
  }
}
```

"Veroeffentlichen" klicken.

## 3. Live verifizieren

In der App (Live-URL):
1. Anonym anmelden (sollte automatisch passieren).
2. Tab "Mein Hund" -> "Dokumente" oeffnen.
3. Eine kleine PDF/Bild-Datei hochladen.
4. Es sollte eine Vorschau bzw. Listen-Eintrag erscheinen.

Wenn der Upload fehlschlaegt:
- Browser-DevTools (F12) -> Console pruefen.
- Bei `storage/unauthorized`: Rules pruefen.
- Bei `storage/object-not-found`: Bucket existiert evtl. nicht - Schritt 1 noch nicht
  abgeschlossen.

## 4. Optional - Storage in Code aktivieren

Code laeuft schon mit Storage. Falls in `lib/features/documents/...`
neue Dateifunktionen hinzukommen, das gleiche Schema benutzen:
- Pfad: `users/{uid}/documents/{docId}/{filename}`
- Metadaten zusaetzlich in Firestore-Collection `users/{uid}/documents`.
