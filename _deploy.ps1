$ErrorActionPreference = 'Continue'
$main  = 'c:\Users\admin\Desktop\Hunde App\dogmatch_ai'
$pages = 'c:\Users\admin\Desktop\Hunde App\dogmatch-pages'
$src   = Join-Path $main 'build\web'
$fl    = 'C:\Users\admin\flutter\bin\flutter.bat'
$proxy = 'https://dogmatch-gemini-proxy.marcelfehse22.workers.dev'

Set-Location $main

& $fl analyze --no-pub > _bp_analyze.txt 2>&1
"ANALYZE_EXIT=$LASTEXITCODE"

# Build MIT Worker-URL (Foto-Erkennung), Standard-Flags lt. Constraints.
& $fl build web --base-href "/dogmatch-ai/" --no-pub --no-web-resources-cdn --dart-define=GEMINI_PROXY_URL=$proxy > _bp_build.txt 2>&1
"BUILD_EXIT=$LASTEXITCODE"

# Pflicht: kein Gemini-Key im Bundle.
$keys = Select-String -Path "$src\*.js" -Pattern "AIzaSyB[A-Za-z0-9_-]{30}"
"KEYHITS=$($keys.Count)"
if ($keys.Count -gt 0) { "ABORT_KEY_LEAK"; exit 1 }

# Quellcode-Commit auf main (Phase 1).
git add -A
git commit -m "Phase 1: Tempo + Foto-Auto-Verkleinerung + Senioren-Modus + Spruche + Heute-Karte" -m "#22 Dashboard lazy (CustomScrollView/Sliver) + Rassenliste auf Vorschau begrenzt + cacheWidth fuer Hundefoto. #8 Fotos werden beim Upload automatisch auf 1024px/JPEG verkleinert (Android-Profil-Fix). #11 Senioren-Modus (groessere Schrift). #6 Geld-Sprueche raus, viele neue. #9 Heute-Karte mit Hundefoto-Avatar." -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
"MAIN_COMMIT_EXIT=$LASTEXITCODE"
git push 2>&1 | Out-String | Write-Output
"MAIN_PUSH_DONE"

# Build nach gh-pages spiegeln.
robocopy $src $pages /MIR /XD .git /XF .nojekyll 404.html /NFL /NDL /NJH /NJS | Out-Null
"ROBOCOPY_EXIT=$LASTEXITCODE"
Copy-Item (Join-Path $src 'index.html') (Join-Path $pages '404.html') -Force

Set-Location $pages
git add .
git commit -m "Deploy: Phase 1 (Tempo, Foto-Resize, Senioren-Modus, Heute-Karte)"
"PAGES_COMMIT_EXIT=$LASTEXITCODE"
git push 2>&1 | Out-String | Write-Output
"PAGES_PUSH_DONE"

Set-Location $main
Remove-Item _bp_analyze.txt,_bp_build.txt -ErrorAction SilentlyContinue
"ALL_DONE"
