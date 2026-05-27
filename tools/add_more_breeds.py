"""
Idempotent: fuegt fehlende FCI-Rassen in assets/data/breeds.json ein.

Nimmt eine kuratierte Liste von Rassen mit minimalen Feldern + Wikipedia-DE-Lemma
und reichert sie mit Default-Werten an. Das Bild wird via MediaWiki-API auf
upload.wikimedia.org aufgeloest (CORS-safe in Flutter Web / CanvasKit).

Aufruf:
  python tools/add_more_breeds.py [--dry-run]

Bestehende IDs werden nicht ueberschrieben.
"""

import argparse
import json
import sys
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Optional

BREEDS_JSON = Path(__file__).resolve().parent.parent / "assets" / "data" / "breeds.json"

# Minimaler Datensatz pro neuer Rasse:
#   id, name, origin, size, fciGroup, lemma (Wikipedia-DE-Titel fuer Bild)
# Optional: description, temperament, traits, careTips, weightKgMin/Max, etc.
# Was nicht angegeben ist, bekommt sinnvolle Defaults (siehe DEFAULTS).
NEW_BREEDS = [
    # --- Gruppe 1 ---
    {
        "id": "australian-kelpie",
        "name": "Australian Kelpie",
        "origin": "Australien",
        "size": "medium",
        "fciGroup": "Gruppe 1 - Huetehunde",
        "lemma": "Australian Kelpie",
        "description": "Wendiger Huetehund aus Australien - extrem ausdauernd, klug, brauchen Aufgabe.",
        "energyLevel": "veryHigh",
        "temperament": "Klug, arbeitswillig, sensibel",
        "exerciseNeed": 5,
        "beginnerFriendliness": 1,
        "trainability": 5,
    },
    {
        "id": "mudi",
        "name": "Mudi",
        "origin": "Ungarn",
        "size": "small",
        "fciGroup": "Gruppe 1 - Huetehunde",
        "lemma": "Mudi",
        "description": "Mittelgrosser ungarischer Huetehund - lebhaft, neugierig, vielseitig.",
        "energyLevel": "high",
        "temperament": "Aufgeweckt, mutig, lernfreudig",
    },
    {
        "id": "schapendoes",
        "name": "Schapendoes",
        "origin": "Niederlande",
        "size": "medium",
        "fciGroup": "Gruppe 1 - Huetehunde",
        "lemma": "Schapendoes",
        "description": "Niederlaendischer Huetehund mit zottigem Fell - froehlich, agil, freundlich.",
        "energyLevel": "high",
        "temperament": "Lebhaft, freundlich, unabhaengig",
    },
    {
        "id": "pyrenaeen-schaeferhund",
        "name": "Pyrenaeen-Schaeferhund",
        "origin": "Frankreich",
        "size": "small",
        "fciGroup": "Gruppe 1 - Huetehunde",
        "lemma": "Pyrenäen-Schäferhund",
        "description": "Kleiner aber zaeher Huetehund aus den Pyrenaeen - extrem ausdauernd.",
        "energyLevel": "veryHigh",
        "temperament": "Aufmerksam, mutig, sensibel",
    },
    {
        "id": "maremmen-abruzzen-schaeferhund",
        "name": "Maremmen-Abruzzen-Schaeferhund",
        "origin": "Italien",
        "size": "large",
        "fciGroup": "Gruppe 1 - Huetehunde",
        "lemma": "Maremmen-Abruzzen-Schäferhund",
        "description": "Italienischer Herdenschutzhund - selbststaendig, schuetzend, ruhig.",
        "energyLevel": "medium",
        "temperament": "Wuerdevoll, selbststaendig, treu",
        "beginnerFriendliness": 1,
        "apartmentSuitable": False,
    },
    # --- Gruppe 2 ---
    {
        "id": "aidi",
        "name": "Aidi (Atlas-Schaeferhund)",
        "origin": "Marokko",
        "size": "medium",
        "fciGroup": "Gruppe 2 - Pinscher, Schnauzer, Molossoide",
        "lemma": "Aidi",
        "description": "Marokkanischer Berghund - zaeh, wachsam, treuer Familienhund.",
        "energyLevel": "high",
        "temperament": "Mutig, wachsam, ausdauernd",
    },
    {
        "id": "castro-laboreiro",
        "name": "Cao de Castro Laboreiro",
        "origin": "Portugal",
        "size": "large",
        "fciGroup": "Gruppe 2 - Pinscher, Schnauzer, Molossoide",
        "lemma": "Cão de Castro Laboreiro",
        "description": "Portugiesischer Herdenschutzhund - kraeftig, ruhig, anhaenglich an seine Familie.",
        "energyLevel": "medium",
        "temperament": "Wachsam, gelassen, treu",
    },
    {
        "id": "hollandse-smoushond",
        "name": "Hollaendischer Smoushond",
        "origin": "Niederlande",
        "size": "medium",
        "fciGroup": "Gruppe 2 - Pinscher, Schnauzer, Molossoide",
        "lemma": "Hollandse Smoushond",
        "description": "Niederlaendischer Stallhund - freundlich, robust, anpassungsfaehig.",
        "energyLevel": "medium",
        "temperament": "Heiter, freundlich, treu",
    },
    {
        "id": "continental-bulldog",
        "name": "Continental Bulldog",
        "origin": "Schweiz",
        "size": "medium",
        "fciGroup": "Gruppe 2 - Pinscher, Schnauzer, Molossoide",
        "lemma": "Continental Bulldog",
        "description": "Schweizer Neuzucht - athletischere Variante der Englischen Bulldogge.",
        "energyLevel": "medium",
        "temperament": "Selbstbewusst, ausgeglichen, freundlich",
    },
    # --- Gruppe 3 ---
    {
        "id": "patterdale-terrier",
        "name": "Patterdale Terrier",
        "origin": "Grossbritannien",
        "size": "small",
        "fciGroup": "Gruppe 3 - Terrier",
        "lemma": "Patterdale Terrier",
        "description": "Kompakter Arbeitsterrier - mutig, energiegeladen, kein Anfaenger-Hund.",
        "energyLevel": "veryHigh",
        "temperament": "Mutig, hartnaeckig, selbstbewusst",
        "beginnerFriendliness": 1,
    },
    {
        "id": "brasilianischer-terrier",
        "name": "Brasilianischer Terrier",
        "origin": "Brasilien",
        "size": "small",
        "fciGroup": "Gruppe 3 - Terrier",
        "lemma": "Brasilianischer Terrier",
        "description": "Lebhafter brasilianischer Terrier - klug, aufmerksam, familienfreundlich.",
        "energyLevel": "high",
        "temperament": "Wachsam, lebhaft, anhaenglich",
    },
    # --- Gruppe 5 ---
    {
        "id": "norwegischer-lundehund",
        "name": "Norwegischer Lundehund",
        "origin": "Norwegen",
        "size": "small",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Norwegischer Lundehund",
        "description": "Sechszehiger Spitz aus Norwegen - selten, urspruenglich Papageientaucher-Jaeger.",
        "energyLevel": "medium",
        "temperament": "Munter, eigensinnig, freundlich",
    },
    {
        "id": "norrbottenspitz",
        "name": "Norrbottenspitz",
        "origin": "Schweden",
        "size": "small",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Norrbottenspitz",
        "description": "Schwedischer Jagdspitz - klein, ausdauernd, freundlich.",
        "energyLevel": "high",
        "temperament": "Wachsam, mutig, anhaenglich",
    },
    {
        "id": "kanaan-hund",
        "name": "Kanaan-Hund",
        "origin": "Israel",
        "size": "medium",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Kanaan-Hund",
        "description": "Urspruenglicher Hund vom Typ Pariah - wachsam, robust, sehr eigenstaendig.",
        "energyLevel": "high",
        "temperament": "Wachsam, misstrauisch gegenueber Fremden, treu",
    },
    {
        "id": "thai-ridgeback",
        "name": "Thai Ridgeback",
        "origin": "Thailand",
        "size": "medium",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Thai Ridgeback",
        "description": "Thailaendischer Urtyp mit Aalstrich - klug, sportlich, selbstbewusst.",
        "energyLevel": "high",
        "temperament": "Aufmerksam, schnell, eigenstaendig",
    },
    {
        "id": "jindo",
        "name": "Korea Jindo",
        "origin": "Suedkorea",
        "size": "medium",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Jindo (Hund)",
        "description": "Koreanischer Spitz - bekannt fuer Treue, Klugheit und Reinlichkeit.",
        "energyLevel": "high",
        "temperament": "Treu, klug, wachsam",
    },
    {
        "id": "yakutian-laika",
        "name": "Yakutian Laika",
        "origin": "Russland",
        "size": "medium",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Yakutian Laika",
        "description": "Sibirischer Schlittenhund - robust, kaeltetauglich, freundlich.",
        "energyLevel": "veryHigh",
        "temperament": "Freundlich, ausdauernd, arbeitsfreudig",
    },
    {
        "id": "schwedischer-elchhund",
        "name": "Schwedischer Elchhund (Jaemthund)",
        "origin": "Schweden",
        "size": "large",
        "fciGroup": "Gruppe 5 - Spitze und Hunde vom Urtyp",
        "lemma": "Jämthund",
        "description": "Schwedischer Jagdspitz - kraeftig, ruhig, treuer Begleiter.",
        "energyLevel": "high",
        "temperament": "Mutig, ausdauernd, freundlich",
    },
    # --- Gruppe 6 ---
    {
        "id": "harrier",
        "name": "Harrier",
        "origin": "Grossbritannien",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Harrier (Hund)",
        "description": "Englischer Meutehund - athletisch, freundlich, ausdauernd.",
        "energyLevel": "veryHigh",
        "temperament": "Freundlich, gesellig, ausdauernd",
    },
    {
        "id": "grand-bleu-de-gascogne",
        "name": "Grand Bleu de Gascogne",
        "origin": "Frankreich",
        "size": "large",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Grand Bleu de Gascogne",
        "description": "Grosser franzoesischer Laufhund - feines Gehoer, ruhiges Wesen.",
        "energyLevel": "high",
        "temperament": "Ruhig, freundlich, ausdauernd",
    },
    {
        "id": "petit-bleu-de-gascogne",
        "name": "Petit Bleu de Gascogne",
        "origin": "Frankreich",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Petit Bleu de Gascogne",
        "description": "Kleinere Variante des Grand Bleu - vielseitiger Jagdhund.",
        "energyLevel": "high",
        "temperament": "Lebhaft, freundlich, sanft",
    },
    {
        "id": "berner-laufhund",
        "name": "Berner Laufhund",
        "origin": "Schweiz",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Berner Laufhund",
        "description": "Schweizer Schweisshund mit feiner Nase und ruhigem Wesen.",
        "energyLevel": "high",
        "temperament": "Sanft, ausdauernd, freundlich",
    },
    {
        "id": "luzerner-laufhund",
        "name": "Luzerner Laufhund",
        "origin": "Schweiz",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Luzerner Laufhund",
        "description": "Schweizer Laufhund mit gepunktetem Fell - lebhaft, freundlich.",
        "energyLevel": "high",
        "temperament": "Lebhaft, anhaenglich, klug",
    },
    {
        "id": "brandlbracke",
        "name": "Brandlbracke",
        "origin": "Oesterreich",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Brandlbracke",
        "description": "Oesterreichische Bracke - ausdauernd, mit ruhigem Wesen im Haus.",
        "energyLevel": "high",
        "temperament": "Klug, freundlich, ausdauernd",
    },
    {
        "id": "steirische-rauhhaarbracke",
        "name": "Steirische Rauhhaarbracke",
        "origin": "Oesterreich",
        "size": "medium",
        "fciGroup": "Gruppe 6 - Lauf- und Schweisshunde",
        "lemma": "Steirische Rauhhaarbracke",
        "description": "Robuster Berg-Jagdhund mit dichtem rauen Fell.",
        "energyLevel": "high",
        "temperament": "Mutig, anhaenglich, ausdauernd",
    },
    # --- Gruppe 7 ---
    {
        "id": "drentsche-patrijshond",
        "name": "Drentsche Patrijshond",
        "origin": "Niederlande",
        "size": "medium",
        "fciGroup": "Gruppe 7 - Vorstehhunde",
        "lemma": "Drentsche Patrijshond",
        "description": "Niederlaendischer Vorstehhund - vielseitig, sanft, anpassungsfaehig.",
        "energyLevel": "high",
        "temperament": "Sanft, treu, vielseitig",
    },
    {
        "id": "stabyhoun",
        "name": "Stabyhoun",
        "origin": "Niederlande",
        "size": "medium",
        "fciGroup": "Gruppe 7 - Vorstehhunde",
        "lemma": "Stabyhoun",
        "description": "Seltener niederlaendischer Vorstehhund - sanft, kinderlieb, ausgeglichen.",
        "energyLevel": "medium",
        "temperament": "Sanft, ausgeglichen, freundlich",
    },
    {
        "id": "slowakischer-rauhhaariger-vorstehhund",
        "name": "Slowakischer Rauhhaariger Vorstehhund",
        "origin": "Slowakei",
        "size": "large",
        "fciGroup": "Gruppe 7 - Vorstehhunde",
        "lemma": "Slowakischer Rauhhaariger Vorstehhund",
        "description": "Vielseitiger Jagdhund - ausdauernd, klug, ruhig im Haus.",
        "energyLevel": "high",
        "temperament": "Aufmerksam, lernfreudig, ruhig",
    },
    # --- Gruppe 8 ---
    {
        "id": "deutscher-wachtelhund",
        "name": "Deutscher Wachtelhund",
        "origin": "Deutschland",
        "size": "medium",
        "fciGroup": "Gruppe 8 - Apportier-, Stoeber- und Wasserhunde",
        "lemma": "Deutscher Wachtelhund",
        "description": "Vielseitiger deutscher Stoeberhund - ausdauernd, anhaenglich, lernfreudig.",
        "energyLevel": "high",
        "temperament": "Lernfreudig, ausdauernd, anhaenglich",
    },
    {
        "id": "lagotto-romagnolo-truffeljagd",
        "name": "Lagotto Romagnolo (Trueffel-Variante)",
        "origin": "Italien",
        "size": "medium",
        "fciGroup": "Gruppe 8 - Apportier-, Stoeber- und Wasserhunde",
        "lemma": "Lagotto Romagnolo",
        "description": "Italienischer Trueffelsuchhund - klug, anhaenglich, wenig haarend.",
        "energyLevel": "high",
        "temperament": "Klug, treu, arbeitsfreudig",
    },
    # --- Gruppe 9 ---
    {
        "id": "kromfohrlander-glatthaar",
        "name": "Kromfohrlaender (Glatthaar)",
        "origin": "Deutschland",
        "size": "small",
        "fciGroup": "Gruppe 9 - Gesellschafts- und Begleithunde",
        "lemma": "Kromfohrländer",
        "description": "Junge deutsche Rasse - froehlich, anhaenglich, idealer Familien-Begleithund.",
        "energyLevel": "medium",
        "temperament": "Froehlich, anhaenglich, lernfreudig",
        "apartmentSuitable": True,
    },
    {
        "id": "kontinentaler-zwergspaniel",
        "name": "Kontinentaler Zwergspaniel (Phalene)",
        "origin": "Frankreich/Belgien",
        "size": "toy",
        "fciGroup": "Gruppe 9 - Gesellschafts- und Begleithunde",
        "lemma": "Kontinentaler Zwergspaniel",
        "description": "Eleganter kleiner Begleithund mit haengenden Ohren - klug, lebhaft.",
        "energyLevel": "medium",
        "temperament": "Klug, freundlich, aufmerksam",
    },
    # --- Gruppe 10 ---
    {
        "id": "spanischer-windhund",
        "name": "Spanischer Windhund (Galgo Espanol)",
        "origin": "Spanien",
        "size": "large",
        "fciGroup": "Gruppe 10 - Windhunde",
        "lemma": "Galgo Español",
        "description": "Eleganter spanischer Windhund - sanft, ruhig im Haus, sehr schnell draussen.",
        "energyLevel": "high",
        "temperament": "Sanft, ruhig, sensibel",
    },
    {
        "id": "polnischer-windhund-chart",
        "name": "Polnischer Windhund (Chart Polski)",
        "origin": "Polen",
        "size": "large",
        "fciGroup": "Gruppe 10 - Windhunde",
        "lemma": "Chart Polski",
        "description": "Kraeftiger polnischer Windhund - mutig, selbstbewusst, treu.",
        "energyLevel": "high",
        "temperament": "Selbstbewusst, mutig, treu",
    },
]


DEFAULTS = {
    "temperament": "Freundlich, ausgeglichen, anhaenglich",
    "description": "FCI-anerkannte Rasse.",
    "energyLevel": "medium",
    "grooming": 3,
    "shedding": 3,
    "childFriendliness": 3,
    "beginnerFriendliness": 3,
    "trainability": 3,
    "exerciseNeed": 3,
    "lifeExpectancyYears": 12,
    "weightKgMin": 10.0,
    "weightKgMax": 25.0,
    "monthlyCostEur": 85,
    "commonHealthIssues": [],
    "traits": [],
    "coatType": "Kurzhaar",
    "idealOwner": "Aktive Familien oder erfahrene Halter",
    "dailyExerciseHours": 1.0,
    "noiseLevel": 2,
    "apartmentSuitable": True,
    "goodWithCats": True,
    "typicalTasks": [],
    "countryInfo": {},
    "insurance": {
        "liabilityMonthlyMin": 5,
        "liabilityMonthlyMax": 12,
        "healthMonthlyMin": 25,
        "healthMonthlyMax": 65,
        "opMonthlyMin": 10,
        "opMonthlyMax": 28,
        "listenhundSurcharge": False,
        "notes": None,
    },
    "acquisitionCostEurMin": 1200,
    "acquisitionCostEurMax": 2500,
    "dailyFoodCostEur": 2.8,
    "vetCostPerYearEur": 220,
    "careTips": [
        "Regelmaessig Fell und Ohren kontrollieren.",
        "Mind. 1 h Bewegung pro Tag - Auslastung im Kopf nicht vergessen.",
        "Junghunde nicht ueberlasten - langsam an Belastung gewoehnen.",
    ],
}


def fetch_image_url(lemma: str) -> Optional[str]:
    """MediaWiki-API: Hauptbild eines Wikipedia-Artikels als upload.wikimedia.org-URL."""
    if not lemma:
        return None
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
    try:
        req = urllib.request.Request(
            url,
            headers={"User-Agent": "DogMatchAI-BreedImporter/1.0 (test)"},
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        pages = data.get("query", {}).get("pages", {})
        for _, page in pages.items():
            src = page.get("original", {}).get("source")
            if src and src.startswith("https://upload.wikimedia.org/"):
                return src
    except Exception as e:
        print(f"  ! Bild-Lookup fuer '{lemma}' fehlgeschlagen: {e}", file=sys.stderr)
    return None


def build_entry(base: dict) -> dict:
    """Mischt DEFAULTS mit den base-Feldern. Loest das Bild ueber MediaWiki auf."""
    out = dict(DEFAULTS)
    out.update({k: v for k, v in base.items() if k != "lemma"})
    image = fetch_image_url(base.get("lemma", ""))
    out["imageUrl"] = image or (
        # Generischer Platzhalter (CORS-freundlich) - Wikipedia-Hundesymbol
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Golde33443.jpg/640px-Golde33443.jpg"
    )
    return out


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    with BREEDS_JSON.open("r", encoding="utf-8") as f:
        data = json.load(f)
    existing_ids = {b["id"] for b in data}

    added: list[dict] = []
    skipped = 0
    for base in NEW_BREEDS:
        bid = base["id"]
        if bid in existing_ids:
            skipped += 1
            continue
        print(f"+ {bid} -> {base['name']}")
        entry = build_entry(base)
        added.append(entry)

    print()
    print(f"Bestehend: {len(data)} | Neu: {len(added)} | Uebersprungen: {skipped}")

    if args.dry_run:
        print("(dry-run, keine Aenderung an der JSON)")
        return 0

    if not added:
        print("Nichts hinzuzufuegen.")
        return 0

    data.extend(added)
    with BREEDS_JSON.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"-> {BREEDS_JSON} aktualisiert ({len(data)} Rassen).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
