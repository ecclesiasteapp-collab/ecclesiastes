# Guide de Lancement de l'Application Ecclesiaste avec Flutter

## 📋 Résumé des Corrections Apportées

### 0. **Compatibilité Web et Chrome**

#### ✅ Correctifs récents
- **Import de fichiers web sécurisé** : `EventFileImportService` n'utilise plus `dart:io` dans le flux Chrome
- **Lecture en mémoire** : les imports CSV, Excel et ICS passent par `FilePicker` avec `bytes`
- **Isolation des tâches de fond** : `workmanager_setup.dart` et `background_sync_service.dart` utilisent désormais des exports conditionnels pour éviter de charger `workmanager` côté web
- **Robustesse UI** : correction de la null-safety dans `dashboard_membre_page.dart` et sécurisation de l'affichage de l'identifiant membre
- **Ouverture de fichiers web** : `FileService` résout mieux les URL d'assets et sait ouvrir des octets via `data:` URI sur navigateur

### 1. **Harmonisation des Modules**

#### ✅ Bibliothèque
- Modèle `LibraryDocument` : Complet avec contrôle d'accès par catégorie, niveau et commission
- Stockage : Box Hive `'bibliotheque'` via `DatabaseHelper`
- Fonctionnalité : Affichage et gestion des documents

#### ✅ Annonces
- Modèle `News` : Complet avec support des pièces jointes (`posterAttachment`)
- Stockage : Box Hive `'news'`
- Fonctionnalité : Création, affichage et gestion des annonces

#### ✅ Calendriers et Programmes
- **Correction majeure** : Unification du stockage des événements
  - **Avant** : Les événements importés étaient sauvegardés dans `'events_box'` mais le calendrier lisait depuis `'evenements_map'`
  - **Après** : Tous les événements sont maintenant sauvegardés dans `'evenements_map'` via `DatabaseHelper.insertEvenement()`
- Modèle `Event` : Complet avec support des dates, lieux, responsables et types d'événements
- Modèle `Activite` : Support des activités dans les programmes

### 2. **Importation de Fichiers et Événements**

#### ✅ Nouveau Service : `EventFileImportService`
Localisation : `lib/services/event_file_import_service.dart`

**Fonctionnalités** :
- **Import CSV** : Format `Date (DD/MM/YYYY) | Heure (HH:MM) | Titre | Lieu | Officiant`
- **Import Excel** : Support des fichiers `.xlsx` et `.xls`
- **Import ICS** : Support du format iCalendar (`.ics`)
- **Détection automatique** : Détecte le type d'événement basé sur le titre
- **Gestion des erreurs** : Traitement robuste des erreurs de parsing

#### ✅ Page d'Import Mise à Jour : `ImportEventsPage`
Localisation : `lib/views/import_events_page.dart`

**Améliorations** :
- Bouton d'import de fichiers (CSV, XLSX, ICS)
- Option de copier-coller textuel (existante)
- Aperçu des événements avant validation
- Sauvegarde dans la bonne box Hive (`'evenements_map'`)
- Gestion des erreurs avec messages utilisateur

### 3. **Dépendances Ajoutées**

```yaml
csv: ^6.0.0        # Parsing de fichiers CSV
excel: ^4.0.3      # Parsing de fichiers Excel
```

Ces dépendances permettent l'importation de fichiers structurés.

---

## 🚀 Instructions de Lancement

### Prérequis
- Flutter SDK (version 3.0.0 ou supérieure)
- Chrome (pour `flutter run -d chrome`)
- Git (pour les opérations de versioning)

### Étape 1 : Préparation de l'Environnement

```bash
# Accéder au répertoire du projet
cd C:\Users\nestormbuyi\AndroidStudioProjects\assets\gemini\ecclesiaste

# Vérifier que Flutter est installé
flutter --version

# Vérifier que Chrome est disponible
flutter devices
```

### Étape 2 : Installer les Dépendances

```bash
# Nettoyer les caches précédents
flutter clean

# Récupérer les dépendances
flutter pub get

# Générer les fichiers Hive (modèles)
flutter pub run build_runner build --delete-conflicting-outputs
```

**Note** : Si vous rencontrez une erreur `Duplicate mapping key` lors du `build_runner`, vérifiez que le fichier `pubspec.yaml` n'a pas d'entrées dupliquées (en particulier `share_plus`).

### Étape 3 : Vérifier la Compilation

```bash
# Analyser le code pour les erreurs
flutter analyze

# Lancer les tests (si disponibles)
flutter test
```

### Étape 4 : Lancer l'Application

```bash
# Lancer sur Chrome (web)
flutter run -d chrome

# Variante utile si le debugger Chrome ne s'attache pas
flutter run -d web-server --web-port 7357

# Alternative navigateur
flutter run -d edge

# Ou sur un appareil Android/iOS
flutter run -d <device_id>
```

### Étape 5 : Accéder aux Modules

Une fois l'application lancée, accédez aux modules :

- **Bibliothèque** : Menu principal → Bibliothèque
- **Annonces** : Menu principal → Annonces
- **Calendrier & Programmes** : Menu principal → Calendrier & Programmes
  - Bouton d'import : Permet d'importer des fichiers CSV/XLSX/ICS
- **Hub Réseaux** : Menu principal → Hub Réseaux (YouTube & Facebook)

---

## 🔧 Dépannage

### Problème 1 : "Duplicate mapping key" dans pubspec.yaml

**Symptôme** :
```
Error on line 80, column 3: Duplicate mapping key.
```

**Solution** :
1. Ouvrir `pubspec.yaml`
2. Rechercher les entrées dupliquées (ex: `share_plus` apparaît deux fois)
3. Supprimer l'une des entrées dupliquées
4. Relancer `flutter pub get`

### Problème 2 : "Les événements importés ne s'affichent pas dans le calendrier"

**Symptôme** : Vous importez des événements, mais ils n'apparaissent pas dans le calendrier.

**Cause** : Les événements étaient sauvegardés dans la mauvaise box Hive.

**Solution** : Cette correction a été apportée. Les événements sont maintenant sauvegardés via `DatabaseHelper.insertEvenement()` qui utilise la box `'evenements_map'` correcte.

### Problème 3 : "Erreur lors de l'importation d'un fichier CSV/XLSX"

**Symptôme** :
```
Erreur lors de l'importation: ...
```

**Solutions** :
1. Vérifiez le format du fichier :
   - **CSV** : Colonnes séparées par des virgules ou des points-virgules
   - **XLSX** : Format Excel standard
   - **ICS** : Format iCalendar standard
2. Vérifiez que le fichier n'est pas vide
3. Vérifiez que les dates sont au format `DD/MM/YYYY`
4. Vérifiez que les heures sont au format `HH:MM`

### Problème 4 : "Les pièces jointes des événements ne sont pas sauvegardées"

**Symptôme** : Vous ajoutez une pièce jointe à un événement, mais elle n'est pas persistée.

**Cause** : Le code sauvegarde uniquement les métadonnées de la pièce jointe, pas le contenu du fichier.

**Solution** : Utilisez le service `AttachmentStorageService` pour persister le contenu du fichier. Exemple :
```dart
// Sauvegarder la pièce jointe
await AttachmentStorageService.saveAttachment(attachment);

// Récupérer la pièce jointe
final attachment = await AttachmentStorageService.getAttachment(attachmentId);
```

### Problème 5 : "flutter run -d chrome" ne fonctionne pas

**Symptôme** :
```
Error: Device chrome not found.
```

**Solutions** :
1. Vérifiez que Chrome est installé sur votre machine
2. Vérifiez que le support web de Flutter est activé :
   ```bash
   flutter config --enable-web
   ```
3. Relancez la commande :
   ```bash
   flutter run -d chrome
   ```

### Problème 6 : "Failed to connect to the web debug service"

**Symptôme** :
```text
Failed to establish connection with the web debug service
Failed to connect to the web debug service.
```

**Cause probable** :
- Le code compile, mais l'attache DWDS du navigateur expire
- Le problème peut venir d'une session Chrome bloquée, d'un port occupé ou d'un timeout du debugger web

**Solutions** :
1. Fermer toutes les fenêtres Chrome/Edge lancées par Flutter puis relancer `flutter run -d chrome`
2. Tester `flutter run -d edge`
3. Tester `flutter run -d web-server --web-port 7357` pour vérifier que l'application tourne indépendamment du debugger Chrome
4. Si le build web a déjà cassé auparavant, vérifier que les services web n'importent pas directement `dart:io` ou `workmanager`

### Problème 7 : "Erreur de compilation : Missing import"

**Symptôme** :
```
Error: The method 'EventFileImportService.pickAndImportFile' isn't defined.
```

**Solution** :
1. Vérifiez que le fichier `lib/services/event_file_import_service.dart` existe
2. Vérifiez que l'import est correct dans `import_events_page.dart` :
   ```dart
   import '../services/event_file_import_service.dart';
   ```
3. Relancez `flutter pub get` et `flutter pub run build_runner build`

---

## 🧠 Règles de Compatibilité Web

- Ne jamais importer `dart:io` dans un fichier atteint par le routeur ou `main.dart`
- Encapsuler les dépendances non web comme `workmanager` derrière des exports conditionnels `stub` / `io`
- Pour les imports de fichiers côté navigateur, préférer `FilePicker` avec `withData: true`
- Pour les dashboards, éviter les accès nullables non protégés sur les modèles utilisateur
- Après toute correction liée au lancement, mettre à jour ce guide pour conserver l'historique technique

---

## 📊 Architecture des Modules

### Bibliothèque
```
DatabaseHelper
  ↓
Box 'bibliotheque'
  ↓
LibraryDocument (Hive Model)
  ↓
BibliothequeView
```

### Annonces
```
DatabaseHelper
  ↓
Box 'news'
  ↓
News (Hive Model)
  ↓
AnnoncesPage
```

### Calendrier & Programmes
```
ImportEventsPage (Fichier/Texte)
  ↓
EventFileImportService
  ↓
DatabaseHelper.insertEvenement()
  ↓
Box 'evenements_map'
  ↓
Event (Hive Model)
  ↓
CalendrierPage (Affichage)
```

### Hub Réseaux
```
SocialMediaAggregatorService
  ↓
YouTubeIntegrationService + FacebookIntegrationService
  ↓
SocialInteractionTrackerService
  ↓
HubReseauxPage (Affichage)
```

---

## ✅ Checklist de Validation

Avant de considérer le lancement comme réussi, vérifiez :

- [ ] `flutter pub get` s'exécute sans erreur
- [ ] `flutter pub run build_runner build` s'exécute sans erreur
- [ ] `flutter analyze` ne rapporte pas d'erreurs critiques
- [ ] `flutter run -d chrome` lance l'application sans erreur
- [ ] La bibliothèque affiche les documents
- [ ] Les annonces s'affichent correctement
- [ ] Le calendrier affiche les événements
- [ ] L'import de fichiers (CSV/XLSX/ICS) fonctionne
- [ ] Les événements importés apparaissent dans le calendrier
- [ ] Le Hub Réseaux affiche les vidéos YouTube et publications Facebook
- [ ] Les notifications d'Espace Ministres s'affichent correctement

---

## 🎯 Prochaines Étapes Recommandées

1. **Synchronisation Serveur** : Implémenter la synchronisation des événements avec un backend
2. **Webhooks** : Configurer les webhooks Facebook pour les mises à jour en temps réel
3. **Analytics** : Ajouter des tableaux de bord analytiques détaillés
4. **Notifications Push** : Implémenter les notifications push pour les événements
5. **Offline Mode** : Permettre l'accès aux contenus en mode hors ligne
6. **Caching** : Optimiser le caching pour les performances

---

## 📞 Support

Pour toute question ou problème :
1. Consultez ce guide complet
2. Vérifiez les fichiers de configuration (`pubspec.yaml`, `AGENTS.md`)
3. Consultez les logs de l'application : `flutter logs`
4. Consultez la documentation officielle de Flutter : https://flutter.dev/docs

---

*Dernière mise à jour : Juin 2026*
