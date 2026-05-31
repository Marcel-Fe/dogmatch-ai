// DogMatch AI - Gemini-Proxy als Cloudflare Worker.
//
// Zweck: Der Gemini-API-Schluessel bleibt serverseitig (als Secret im
// Worker) und landet NIE im Web-Bundle. Die App spricht nur mit diesem
// Worker; der Worker spricht mit Gemini. So ist auch Bild-Erkennung
// (Vision) moeglich, die der kostenlose Pollinations-Dienst nicht kann.
//
// Erwartetes Request-Format (POST, JSON) - genau wie die App es sendet:
//   { "model": "gemini-2.5-flash",
//     "systemInstruction": "…",
//     "messages": [ { "role": "user"|"model", "text": "…" } ],
//     "image": "data:image/jpeg;base64,…"   // optional
//   }
// Antwort: { "text": "…" }  bzw. bei Fehler { "error": "…" }

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function json(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { ...CORS, 'Content-Type': 'application/json' },
  });
}

export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: CORS });
    }
    if (request.method !== 'POST') {
      return json({ error: 'Nur POST erlaubt.' }, 405);
    }
    if (!env.GEMINI_API_KEY) {
      return json({ error: 'Server ist nicht konfiguriert (kein Schluessel).' }, 500);
    }

    let body;
    try {
      body = await request.json();
    } catch (_) {
      return json({ error: 'Ungueltiger Request-Body.' }, 400);
    }

    const model = body.model || 'gemini-2.5-flash';
    const messages = Array.isArray(body.messages) ? body.messages : [];
    const systemInstruction = body.systemInstruction || '';
    const image = body.image;

    // App-Nachrichten -> Gemini-"contents". Ein Bild wird an die letzte
    // Nutzer-Nachricht geheftet (Multimodal).
    const contents = messages.map((m, i) => {
      const parts = [{ text: m.text || '' }];
      const isLast = i === messages.length - 1;
      if (image && isLast && m.role === 'user') {
        const match = /^data:(.+?);base64,(.*)$/s.exec(image);
        if (match) {
          parts.push({ inlineData: { mimeType: match[1], data: match[2] } });
        }
      }
      return { role: m.role === 'model' ? 'model' : 'user', parts };
    });

    const payload = { contents };
    if (systemInstruction) {
      payload.systemInstruction = { parts: [{ text: systemInstruction }] };
    }

    const url =
      'https://generativelanguage.googleapis.com/v1beta/models/' +
      encodeURIComponent(model) +
      ':generateContent?key=' +
      env.GEMINI_API_KEY;

    let res;
    try {
      res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
    } catch (_) {
      return json({ error: 'Gemini ist gerade nicht erreichbar.' }, 502);
    }

    let data;
    try {
      data = await res.json();
    } catch (_) {
      return json({ error: 'Gemini-Antwort unlesbar.' }, 502);
    }

    if (!res.ok) {
      const msg = (data && data.error && data.error.message) || ('HTTP ' + res.status);
      return json({ error: msg }, res.status);
    }

    const parts =
      (data.candidates &&
        data.candidates[0] &&
        data.candidates[0].content &&
        data.candidates[0].content.parts) ||
      [];
    const text = parts.map((p) => p.text || '').join('').trim();

    if (!text) {
      return json({ error: 'Keine Antwort erhalten.' }, 502);
    }
    return json({ text });
  },
};
