// DogMatch AI - eigener Service-Worker: "stale-while-revalidate".
//
// Ziel: schnelle Ladezeit (Dateien aus dem Cache) UND immer die neueste
// Version nach einem Deploy - ohne dass der Nutzer den Cache manuell leeren
// muss.
//
// Wie es funktioniert:
// - Statische Dateien (main.dart.js, Bilder, Fonts ...) kommen aus dem Cache
//   -> sofort sichtbar.
// - Die kleine Datei flutter_bootstrap.js (~10 KB) wird bei JEDEM Laden frisch
//   vom Server geholt (cache: 'no-store' umgeht den Browser-/CDN-Cache). Sie
//   aendert sich bei jedem Build.
// - Hat sich flutter_bootstrap.js geaendert -> es gab einen neuen Deploy:
//   Cache komplett leeren und die App EINMAL neu laden. Danach sind alle
//   Dateien frisch und konsistent.
//
// Diese Datei wird beim Deploy nach dem Build ueber build/web/
// flutter_service_worker.js kopiert (siehe Deploy-Rezept).

const CACHE = 'dm-swr-v1';

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (e) => e.waitUntil(self.clients.claim()));

// Nur diese (kleinen) Dateien werden bei jedem Laden frisch geprueft.
function isCore(p) {
  return p.endsWith('/flutter_bootstrap.js') ||
      p.endsWith('/') ||
      p.endsWith('/index.html');
}

async function notifyReload() {
  const cs = await self.clients.matchAll({ type: 'window' });
  for (const c of cs) c.postMessage('dm-reload');
}

self.addEventListener('fetch', (e) => {
  const req = e.request;
  const url = new URL(req.url);
  if (req.method !== 'GET' || url.origin !== self.location.origin) return;

  e.respondWith((async () => {
    const cache = await caches.open(CACHE);
    const cached = await cache.match(req);
    const core = isCore(url.pathname);

    // Statisch + schon im Cache -> sofort aus dem Cache (schnell, spart Daten).
    if (cached && !core) return cached;

    // Core-Datei oder noch nicht gecacht -> frisch vom Netz holen.
    try {
      const res = await fetch(req, { cache: 'no-store' });
      if (res && res.status === 200) {
        const before = cached && cached.headers.get('last-modified');
        const after = res.headers.get('last-modified');
        await cache.put(req, res.clone());
        // Neuer Deploy erkannt (Core-Datei hat sich geaendert)?
        if (cached && core && before && after && before !== after) {
          await caches.delete(CACHE);
          await notifyReload();
        }
      }
      return res;
    } catch (err) {
      // Offline: nimm, was im Cache ist.
      return cached || new Response('', { status: 504 });
    }
  })());
});
