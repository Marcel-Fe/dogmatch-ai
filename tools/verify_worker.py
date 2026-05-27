"""
Pingt einen deployten DogMatch-Gemini-Worker und prueft Plausibilitaet.

Aufruf:
  python tools/verify_worker.py <worker-url>

Beispiel:
  python tools/verify_worker.py https://dogmatch-gemini-proxy.example.workers.dev
"""

import json
import sys
import urllib.error
import urllib.request


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: python tools/verify_worker.py <worker-url>", file=sys.stderr)
        return 2

    url = sys.argv[1].rstrip("/")
    payload = json.dumps({
        "messages": [
            {"role": "user", "text": "Antworte nur mit dem Wort 'pong'."}
        ],
    }).encode("utf-8")

    req = urllib.request.Request(
        url,
        data=payload,
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Origin": "https://marcel-fe.github.io",
        },
    )

    print(f"-> POST {url}")
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            status = resp.status
            body = resp.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        print(f"!! HTTP {e.code}: {e.reason}")
        try:
            print(e.read().decode("utf-8"))
        except Exception:
            pass
        return 1
    except Exception as e:
        print(f"!! Verbindung fehlgeschlagen: {e}")
        return 1

    print(f"<- HTTP {status}")
    try:
        data = json.loads(body)
    except Exception:
        print(f"Antwort kein JSON:\n{body}")
        return 1

    text = data.get("text") or data.get("reply") or ""
    print(f"Antwort-Text: {text!r}")

    ok = bool(text.strip())
    print()
    print("OK" if ok else "LEER")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
