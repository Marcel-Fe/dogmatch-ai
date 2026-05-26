/**
 * Gemini-Proxy als Cloudflare Worker.
 *
 * Akzeptiert POST mit JSON:
 *   {
 *     "messages": [{"role": "user"|"model", "text": "..."}, ...],
 *     "image": "data:image/jpeg;base64,..."   // optional
 *     "model": "gemini-2.5-flash",            // optional, default unten
 *     "systemInstruction": "..."              // optional
 *   }
 *
 * Antwort:
 *   { "text": "..." }   bei Erfolg
 *   { "error": "..." }  bei Fehler (mit Status >= 400)
 *
 * Sicherheit:
 *   - GEMINI_KEY ist ein Worker-Secret (`wrangler secret put GEMINI_KEY`)
 *   - CORS auf ALLOWED_ORIGIN (Env-Var) beschraenkt - default *
 *   - Methode auf POST + OPTIONS beschraenkt
 */

const DEFAULT_MODEL = 'gemini-2.5-flash';

function corsHeaders(env, requestOrigin) {
  const allowed = env.ALLOWED_ORIGIN || '*';
  // Wenn ALLOWED_ORIGIN auf "*", echoen wir es. Wenn konkret, nur dann
  // antworten wenn Origin passt.
  let origin = '*';
  if (allowed !== '*') {
    origin = requestOrigin === allowed ? allowed : '';
  }
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
    'Vary': 'Origin',
  };
}

function jsonResponse(body, status, headers = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...headers },
  });
}

function dataUrlToInlineData(dataUrl) {
  const m = /^data:([^;]+);base64,(.+)$/.exec(dataUrl);
  if (!m) return null;
  return { mimeType: m[1], data: m[2] };
}

export default {
  async fetch(request, env) {
    const cors = corsHeaders(env, request.headers.get('Origin'));

    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: cors });
    }
    if (request.method !== 'POST') {
      return jsonResponse({ error: 'Method not allowed' }, 405, cors);
    }
    if (!env.GEMINI_KEY) {
      return jsonResponse(
        { error: 'Server misconfigured: GEMINI_KEY fehlt' },
        500,
        cors,
      );
    }

    let body;
    try {
      body = await request.json();
    } catch (e) {
      return jsonResponse({ error: 'Invalid JSON' }, 400, cors);
    }

    const messages = Array.isArray(body.messages) ? body.messages : [];
    if (messages.length === 0) {
      return jsonResponse({ error: 'messages leer' }, 400, cors);
    }

    const model = (body.model || DEFAULT_MODEL).replace(/[^a-zA-Z0-9.\-_]/g, '');
    const sysText = typeof body.systemInstruction === 'string'
      ? body.systemInstruction
      : null;

    // Gemini-Request bauen
    const contents = messages.map((m, i) => {
      const role = m.role === 'model' || m.role === 'assistant' ? 'model' : 'user';
      const parts = [];
      // Bild nur an die *letzte* user-Nachricht haengen
      if (i === messages.length - 1 && role === 'user' && body.image) {
        const inline = dataUrlToInlineData(body.image);
        if (inline) parts.push({ inlineData: inline });
      }
      parts.push({ text: m.text ?? m.content ?? '' });
      return { role, parts };
    });

    const geminiBody = {
      contents,
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 800,
      },
    };
    if (sysText) {
      geminiBody.systemInstruction = { role: 'user', parts: [{ text: sysText }] };
    }

    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${env.GEMINI_KEY}`;
    let upstream;
    try {
      upstream = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(geminiBody),
      });
    } catch (e) {
      return jsonResponse({ error: `Gemini-Upstream fetch failed: ${e}` }, 502, cors);
    }

    const upstreamJson = await upstream.json().catch(() => ({}));
    if (!upstream.ok) {
      const msg = upstreamJson?.error?.message || `HTTP ${upstream.status}`;
      return jsonResponse({ error: msg }, upstream.status, cors);
    }

    const text = upstreamJson?.candidates?.[0]?.content?.parts
      ?.map((p) => p.text || '')
      .join('') || '';
    if (!text) {
      return jsonResponse({ error: 'Gemini-Antwort leer' }, 502, cors);
    }
    return jsonResponse({ text }, 200, cors);
  },
};
