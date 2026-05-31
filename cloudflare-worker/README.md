# Bilderkennung aktivieren (Gemini-Proxy)

Damit die KI **Fotos deines Hundes erkennen** kann, braucht es einen winzigen
Server-Baustein. Der hält deinen Gemini-Schlüssel geheim (er landet nie in der
Web-App) und leitet Anfragen an Google Gemini weiter – inklusive Bildern.

Das Ganze ist **kostenlos** (Cloudflare-Gratisplan + Gemini-Gratiskontingent)
und in ~10 Minuten erledigt.

## Was du brauchst
- Einen kostenlosen **Cloudflare**-Account: https://dash.cloudflare.com/sign-up
- Deinen **Gemini-API-Schlüssel** (beginnt mit `AIza…`):
  https://aistudio.google.com/app/apikey
- **Node.js** auf dem PC (für den Befehl `npx`): https://nodejs.org

## Schritt für Schritt

1. Terminal in diesem Ordner öffnen (`cloudflare-worker`).

2. Bei Cloudflare anmelden:
   ```
   npx wrangler login
   ```
   (Öffnet den Browser – einmal bestätigen.)

3. Deinen Gemini-Schlüssel als **Secret** hinterlegen (wird verschlüsselt
   gespeichert, niemals im Code):
   ```
   npx wrangler secret put GEMINI_API_KEY
   ```
   Dann den `AIza…`-Schlüssel einfügen und Enter.

4. Den Worker veröffentlichen:
   ```
   npx wrangler deploy
   ```
   Am Ende zeigt die Ausgabe eine **URL** wie:
   ```
   https://dogmatch-gemini-proxy.DEIN-NAME.workers.dev
   ```
   **Diese URL kopieren.**

5. Mir (Claude) die URL geben. Ich baue die App damit neu
   (`--dart-define=GEMINI_PROXY_URL=…`) und deploye sie. Danach erkennt die
   KI Fotos.

## Sicherheit
- Der Schlüssel liegt nur als Cloudflare-Secret vor, nie im Web-Bundle.
- Die Worker-URL selbst ist nicht geheim (sie enthält keinen Schlüssel).
- Tipp: Falls du den Worker nur für deine App nutzen willst, kannst du in
  `worker.js` bei `Access-Control-Allow-Origin` statt `*` deine Domain
  (`https://marcel-fe.github.io`) eintragen.

## Kosten im Blick behalten
- Cloudflare Worker Gratis: 100.000 Anfragen/Tag.
- Gemini Gratis-Tier: großzügiges Tageslimit. Bei sehr viel Nutzung kann
  Google zur Abrechnung auffordern – dann im Google-AI-Studio ein Limit setzen.
