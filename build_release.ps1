# build_release.ps1
Write-Host "🚀 Démarrage du build de production pour Ecclésiastes..." -ForegroundColor Green

# 1. Nettoyage
Write-Host "🧹 Nettoyage du projet..." -ForegroundColor Yellow
flutter clean
flutter pub get

# 2. Analyse statique et Tests
Write-Host "🔍 Analyse du code et tests..." -ForegroundColor Yellow
flutter analyze
# flutter test (Décommentez si vous avez des tests unitaires)

# 3. Build Android (APK avec Obfuscation pour la sécurité)
Write-Host "📦 Génération de l'APK Android (Release + Obfuscation)..." -ForegroundColor Cyan
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# 4. Build Android (AAB pour le Play Store)
Write-Host "📦 Génération de l'AAB pour le Play Store..." -ForegroundColor Cyan
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info

Write-Host "✅ Build terminé avec succès ! Les fichiers sont dans build/app/outputs/" -ForegroundColor Green
