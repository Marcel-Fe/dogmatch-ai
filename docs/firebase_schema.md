# DogMatch AI - Firestore-Schema (Backend-Phase)

> **Status: Dokumentation, noch nicht aktiv.** Phase 1 laeuft rein offline.
> Aktiviert wird das Backend ueber `Env.useFirebase` in
> `lib/core/config/env.dart`.

Dieses Dokument beschreibt das geplante Datenmodell, damit der spaetere
Anschluss von Firebase vorbereitet ist - ohne dass in Phase 1 bereits
Pakete, Konten oder Schluessel noetig sind.

## Collections

### `users/{uid}`
- `displayName`: string
- `email`: string
- `isPremium`: bool
- `themeMode`: string (`system` | `light` | `dark`)
- `createdAt`: timestamp

### `dog_breeds/{breedId}`
Entspricht dem Modell `DogBreed`.
- `name`, `origin`, `temperament`, `description`: string
- `size`: string (`small` | `medium` | `large` | `giant`)
- `energyLevel`: string (`low` | `moderate` | `high` | `veryHigh`)
- `grooming`, `shedding`, `childFriendliness`, `beginnerFriendliness`,
  `trainability`, `exerciseNeed`: number (Skala 1-5)
- `lifeExpectancyYears`, `monthlyCostEur`: number
- `weightKgMin`, `weightKgMax`: number
- `commonHealthIssues`, `traits`: array<string>
- `imageUrl`: string

### `quizzes/{quizId}`
- `version`: number
- `questions`: array (Modell `QuizQuestion`)

### `matches/{matchId}`
- `userId`: string
- `answers`: map<string, array<string>>
- `results`: array `{ breedId, score, reasons, cons }`
- `createdAt`: timestamp

### `favorites/{uid}/items/{breedId}`
- `breedId`: string
- `savedAt`: timestamp

### `chats/{uid}/sessions/{sessionId}`
- `messages`: array `{ role, content, timestamp }`
- `updatedAt`: timestamp

### `subscriptions/{uid}`
- `plan`: string (`free` | `premium`)
- `status`: string
- `renewsAt`: timestamp

### `articles/{articleId}`
- `title`, `category`, `summary`, `content`: string
- `imageUrl`: string
- `readMinutes`: number

### `breeders/{breederId}`
- `name`, `city`, `website`, `imageUrl`: string
- `geo`: geopoint (Grundlage der spaeteren Geo-Umkreissuche)
- `breedIds`: array<string>
- `isVerified`: bool
- `experienceYears`: number
- `averageRating`: number

### `reviews/{reviewId}`
- `breederId`: string
- `authorName`: string
- `rating`: number (1-5)
- `comment`: string
- `createdAt`: timestamp

## Hinweise fuer die Backend-Phase
- **Geo-Suche:** `geo` als `GeoPoint` speichern; fuer Umkreissuchen
  zusaetzlich ein Geohash-Feld vorsehen.
- **Moderation:** `breeders` und `reviews` brauchen einen Freigabe-/
  Verifizierungs-Workflow - nur seriöse Zuechter werden angezeigt.
- **Security Rules:** Schreibzugriff strikt auf den jeweiligen `uid`-Pfad
  begrenzen; `dog_breeds` und `articles` nur lesbar.
