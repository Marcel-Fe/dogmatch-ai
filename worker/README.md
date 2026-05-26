# DogMatch Gemini-Proxy (Cloudflare Worker)

Kostenloser Reverse-Proxy fuer die Gemini-API. Der Gemini-Key liegt nur
hier als Secret bei Cloudflare - nie im Web-Bundle der App.

## Warum?

Der Gemini-Key darf nicht in der Browser-Anwendung sichtbar sein (siehe
Memory `gemini-key-handling.md`). Dieser Worker faengt die Anfragen der App
ab, fuegt den Key an und ruft Gemini auf. Cloudflare Workers haben einen
grosszuegigen Free Tier (100k Requests/Tag) - reicht fuer das Projekt
locker und braucht keine Kreditkarte.

## Einmal-Setup (Cloudflare-Konto + Worker deployen)

### 1. Cloudflare-Konto

- Registrieren unter https://dash.cloudflare.com/sign-up (kostenlos)
- E-Mail bestaetigen, einloggen.

### 2. Wrangler CLI installieren

Voraussetzung: Node.js >= 20 lokal (https://nodejs.org).

```powershell
cd "c:\Users\admin\Desktop\Hunde App\dogmatch_ai\worker"
npm install
```

### 3. Bei Cloudflare einloggen

```powershell
npx wrangler login
```
Es oeffnet sich ein Browser-Fenster - dort "Authorize" klicken.

### 4. Gemini-Key als Secret hinterlegen

```powershell
npx wrangler secret put GEMINI_KEY
```
Wenn die Eingabeaufforderung erscheint, den **Gemini-API-Key** einfuegen
(beginnt typischerweise mit `AIzaSy...`). Der Key landet verschluesselt
bei Cloudflare, nie in dieser Datei.

### 5. Worker deployen

```powershell
npx wrangler deploy
```
Die Ausgabe enthaelt die URL, z. B.:

```
Published dogmatch-gemini-proxy
  https://dogmatch-gemini-proxy.<account>.workers.dev
```

Diese URL kopieren - sie wird beim Flutter-Build mit
`--dart-define=GEMINI_PROXY_URL=...` uebergeben.

### 6. Worker testen

```powershell
curl -X POST "https://<deine-worker-url>" `
     -H "Content-Type: application/json" `
     -d '{"messages":[{"role":"user","text":"Sag Hallo auf Deutsch"}]}'
```

Antwort sollte etwa so aussehen:
```json
{"text":"Hallo! Wie kann ich dir helfen?"}
```

## Flutter-Build mit Proxy

Im Flutter-Projekt-Root:

```powershell
$proxy = "https://dogmatch-gemini-proxy.<account>.workers.dev"
& "C:\Users\admin\flutter\bin\flutter.bat" build web `
    --base-href "/dogmatch-ai/" `
    --dart-define="GEMINI_PROXY_URL=$proxy" `
    --no-pub
```

Im Build-Output ist der Key nicht enthalten - der Worker sitzt davor.

## CORS

Wenn die Live-URL der App sich aendert, in `wrangler.toml` die
`ALLOWED_ORIGIN` anpassen und neu deployen:

```toml
[vars]
ALLOWED_ORIGIN = "https://marcel-fe.github.io"
```

Fuer lokales Testen (`flutter run -d chrome`) ggf. temporaer `*` setzen.
