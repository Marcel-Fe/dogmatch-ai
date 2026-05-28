"""
Findet alle Rassen mit Platzhalter-Bild in breeds.json und holt das echte Bild
von Wikipedia nach. Mit Throttling (1.5s zwischen Requests), retry bei 429.

Aufruf:
  python tools/repair_breed_images.py
"""

import json
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Optional

BREEDS_JSON = Path(__file__).resolve().parent.parent / "assets" / "data" / "breeds.json"
PLACEHOLDER_MARKER = "Golde33443"

# id -> Liste alternativer Wikipedia-Lemmas (DE). Es wird das erste mit Bild genommen.
LEMMAS = {
    "neufundlaender": [
        "Neufundländer (Hunderasse)",
        "Neufundländer (Hund)",
        "Neufundländer",
    ],
    "pyrenaeen-schaeferhund": [
        "Berger des Pyrénées",
        "Pyrenäen-Schäferhund",
        "Pyrenäenschäferhund",
    ],
    "jindo": ["Jindo (Hunderasse)", "Korea Jindo", "Jindo (Hund)"],
    "yakutian-laika": ["Jakutischer Laika", "Yakutian Laika"],
    "harrier": ["Harrier (Hunderasse)", "Harrier (Hund)"],
    "grand-bleu-de-gascogne": [
        "Grand bleu de Gascogne",
        "Grand Bleu de Gascogne",
    ],
    "drentsche-patrijshond": ["Drentse Patrijshond", "Drentsche Patrijshond"],
    "slowakischer-rauhhaariger-vorstehhund": [
        "Slowakischer Rauhbart",
        "Slowakischer rauhaariger Vorstehhund",
    ],
    "kromfohrlander-glatthaar": ["Kromfohrländer"],
    "kontinentaler-zwergspaniel": [
        "Papillon (Hunderasse)",
        "Phalène (Hund)",
        "Kontinentaler Zwergspaniel",
    ],
}


def fetch_image_url(lemma: str, retries: int = 3) -> Optional[str]:
    url = (
        "https://de.wikipedia.org/w/api.php?"
        + urllib.parse.urlencode({
            "action": "query",
            "format": "json",
            "prop": "pageimages",
            "piprop": "original",
            "titles": lemma,
            "redirects": "1",
        })
    )
    for attempt in range(retries):
        try:
            req = urllib.request.Request(
                url,
                headers={"User-Agent": "DogMatchAI-BreedImporter/1.0"},
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            pages = data.get("query", {}).get("pages", {})
            for _, page in pages.items():
                src = page.get("original", {}).get("source")
                if src and src.startswith("https://upload.wikimedia.org/"):
                    return src
            return None
        except urllib.error.HTTPError as e:
            if e.code == 429:
                wait = 3 * (attempt + 1)
                print(f"    429 -> warte {wait}s", file=sys.stderr)
                time.sleep(wait)
                continue
            print(f"    HTTP {e.code}: {e.reason}", file=sys.stderr)
            return None
        except Exception as e:
            print(f"    Fehler: {e}", file=sys.stderr)
            return None
    return None


def main() -> int:
    with BREEDS_JSON.open("r", encoding="utf-8") as f:
        data = json.load(f)

    by_id = {b["id"]: b for b in data}
    targets = []
    for bid in LEMMAS:
        if bid not in by_id:
            continue
        url = by_id[bid].get("imageUrl", "") or ""
        if PLACEHOLDER_MARKER in url or url.strip() == "":
            targets.append(bid)
    print(f"Bilder zum Reparieren: {len(targets)}")

    fixed = 0
    for bid in targets:
        lemmas = LEMMAS[bid]
        img = None
        for lemma in lemmas:
            print(f"- {bid}  -> versuche '{lemma}'")
            img = fetch_image_url(lemma)
            if img:
                break
            time.sleep(1.5)
        if img:
            by_id[bid]["imageUrl"] = img
            print(f"    -> {img}")
            fixed += 1
        else:
            print("    !! kein Bild gefunden")
        time.sleep(1.5)

    if fixed > 0:
        with BREEDS_JSON.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"\n-> {fixed} Bilder aktualisiert in {BREEDS_JSON}")
    else:
        print("Nichts geschrieben.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
