# 📎 SYSTÈME D'ATTACHMENTS ECCLÉSIASTES

## Vue d'ensemble

Système complet de gestion des pièces jointes (fichiers, images, documents) pour l'application **Ecclésiastes**, compatible Web (Chrome) et Mobile (iOS/Android).

### 🎯 Objectifs

- ✅ **Événements** : Joindre des données (CSV, Excel, PDF) aux événements
- ✅ **Annonces** : Joindre des affiches (JPG, PNG, PDF) aux annonces
- ✅ **Web-compatibleWEB** : Fonctionne sur Chrome sans accès au système de fichiers
- ✅ **Mobile** : Fonctionne natif sur Android et iOS
- ✅ **Offline-first** : Données stockées localement avec Hive
- ✅ **Performance** : Limite 5 MB par fichier, ~50 MB par boîte Hive

---

## 📦 Architecture

### Composants

```
lib/
├── models/
│   ├── attachment_model.dart          # Modèle Uint8List (Web-safe)
│   ├── event.dart                      # ChurchEvent étendu
│   └── news_model.dart                 # News étendu
├── services/
│   ├── file_attachment_service.dart    # Sélection + validation fichiers
│   ├── attachment_storage_service.dart # Hive + nettoyage
│   └── attachment_initialization.dart  # Configuration Hive
├── widgets/
│   ├── attachment_picker_widget.dart   # Interface de sélection
│   ├── announcement_card.dart          # Carte annonce avec affiche
│   └── event_card_with_attachment.dart # Carte événement avec données
├── views/
│   ├── create_announcement_page.dart   # Créer annonces
│   ├── announcement_detail_screen.dart # Détail annonce
│   ├── saisie_programme_page.dart      # Créer événements (modifié)
│   ├── simple_action_wizard.dart       # Assistant (modifié)
│   └── attachment_manager_screen.dart  # Admin manager
└── ATTACHMENT_INTEGRATION_GUIDE.dart   # Guide d'intégration
```

### Flux de données

```
Utilisateur sélectionne fichier
    ↓
FileAttachmentService.pickFile()
    ↓
Validation (taille < 5MB, MIME type, etc.)
    ↓
Attachment créé (ID, fileName, mimeType, fileData: Uint8List)
    ↓
Attaché à News/Event
    ↓
AttachmentStorageService.save*() → Hive
    ↓
Stocké dans Boîte Hive ('attachments_box')
    ↓
Affiché avec Image.memory() ou icône document
```

---

## 🚀 Utilisation rapide

### 1. Ajouter un attachement à un formulaire

```dart
AttachmentPickerWidget(
  contextType: 'event', // ou 'announcement'
  onAttachmentChanged: (attachment) {
    setState(() => _myAttachment = attachment);
  },
)
```

### 2. Sauvegarder avec attachement

```dart
await AttachmentStorageService.saveAnnouncementWithAttachment(
  announcement: myNews,
  attachment: _selectedAttachment,
);
```

### 3. Charger et afficher

```dart
final news = await AttachmentStorageService.getAnnouncementWithAttachment(id);

// Afficher l'image
if (news?.posterAttachment?.isImage == true) {
  Image.memory(news!.posterAttachment!.fileData)
}
```

### 4. Nettoyer les orphelins

```dart
// Appeler régulièrement (au démarrage app)
await AttachmentStorageService.cleanupOrphanedAttachments();
```

---

## 📋 Modèles

### Attachment

```dart
@HiveType(typeId: 103)
class Attachment extends HiveObject {
  @HiveField(0) late String id;              // UUID unique
  @HiveField(1) late String fileName;        // Nom du fichier
  @HiveField(2) late String mimeType;        // Type MIME
  @HiveField(3) late Uint8List fileData;     // Contenu binaire (Web-safe!)
  
  bool get isImage => mimeType.startsWith('image/');
  bool get isDocument => mimeType.contains('csv|excel|pdf');
  int get fileSizeInMB => (fileData.lengthInBytes / (1024*1024)).toInt();
}
```

### Event étendu

```dart
@HiveType(typeId: 110)
class ChurchEvent extends HiveObject {
  @HiveField(0-6) // Champs existants
  @HiveField(7) late Attachment? dataAttachment;  // ← NOUVEAU
}
```

### News étendu

```dart
@HiveType(typeId: 40)
class News extends HiveObject {
  @HiveField(0-4) // Champs existants
  @HiveField(5) late Attachment? posterAttachment;  // ← NOUVEAU
}
```

---

## 🔧 Services

### FileAttachmentService

**Sélection de fichiers**

```dart
// Pour événements
final attachment = await FileAttachmentService.pickEventDataFile();
// Extensions: csv, xlsx, xls, pdf

// Pour annonces
final attachment = await FileAttachmentService.pickAnnouncementPoster();
// Extensions: jpg, jpeg, png, pdf
```

**Validation**

```dart
// Vérifie taille (max 5 MB)
bool isValid = FileAttachmentService.isFileSizeValid(fileData);
```

### AttachmentStorageService

**Sauvegarde**

```dart
// Sauvegarde atomique (attachment + parent)
await AttachmentStorageService.saveAnnouncementWithAttachment(
  announcement: myNews,
  attachment: myAttachment,
);

await AttachmentStorageService.saveEventWithAttachment(
  event: myEvent,
  attachment: myAttachment,
);

// Sauvegarde manuelle d'un attachment
await AttachmentStorageService.saveAttachment(attachment);
```

**Chargement**

```dart
final news = await AttachmentStorageService.getAnnouncementWithAttachment(id);
final event = await AttachmentStorageService.getEventWithAttachment(id);
```

**Suppression**

```dart
// Supprime le parent ET son attachment
await AttachmentStorageService.deleteAnnouncementWithAttachment(id);
await AttachmentStorageService.deleteEventWithAttachment(id);

// Supprime juste l'attachment
await AttachmentStorageService.deleteAttachment(id);
```

**Administration**

```dart
// Récupère tous les attachments
final all = await AttachmentStorageService.getAllAttachments();

// Espace utilisé
final sizeInMB = await AttachmentStorageService.getTotalAttachmentSizeInMB();

// Nettoie les orphelins
await AttachmentStorageService.cleanupOrphanedAttachments();
```

---

## 🎨 Widgets

### AttachmentPickerWidget

Interface intuitive pour sélectionner fichiers.

```dart
AttachmentPickerWidget(
  contextType: 'event',
  onAttachmentChanged: (attachment) { /* ... */ },
  initialAttachment: existingAttachment,
  customLabel: 'Votre label personnalisé',
)
```

**États:**
- 📭 Vide : Bouton d'ajout
- 📸 Image sélectionnée : Aperçu image + bouton supprimer/remplacer
- 📄 Document sélectionné : Icône + nom + taille + bouton supprimer/remplacer

### AnnouncementCard

Affiche une annonce avec sa miniature.

```dart
AnnouncementCard(
  announcement: news,
  onTap: () { /* voir détail */ },
  onEdit: () { /* éditer */ },
  onDelete: () { /* supprimer */ },
)
```

### EventCardWithAttachment

Affiche un événement avec icône de données attachées.

```dart
EventCardWithAttachment(
  event: churchEvent,
  onTap: () { /* voir détail */ },
  onEdit: () { /* éditer */ },
  onDelete: () { /* supprimer */ },
)
```

### AnnouncementDetailScreen

Vue complète d'une annonce avec affiche en grand.

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => AnnouncementDetailScreen(
    announcement: news,
    onEdit: () { /* ... */ },
    onDelete: () { /* ... */ },
  ),
));
```

### AttachmentManagerScreen

Dashboard administrateur.

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const AttachmentManagerScreen(),
));
```

---

## 📐 Limites et Spécifications

| Propriété | Valeur |
|-----------|--------|
| **Taille max par fichier** | 5 MB |
| **Taille max total Hive** | ~50 MB |
| **Formats images** | JPG, JPEG, PNG, PDF |
| **Formats données** | CSV, XLSX, XLS, PDF |
| **Stockage** | Hive (local, offline-first) |
| **Compatibilité** | Web (Chrome 90+), Android 5+, iOS 11+ |

---

## 🔄 Flux d'intégration

### Pour les événements

```
1. SaisieProgrammePage
   ├─ AttachmentPickerWidget (event)
   └─ → saveEventWithAttachment()
       → Hive: event_box + attachments_box
       
2. EventCardWithAttachment (liste)
   └─ Affiche icône si données

3. EventDetailScreen
   └─ Affiche données attachées
```

### Pour les annonces

```
1. CreateAnnouncementPage OU SimpleActionWizard
   ├─ AttachmentPickerWidget (announcement)
   └─ → saveAnnouncementWithAttachment()
       → Hive: news_box + attachments_box

2. AnnouncementCard (liste)
   └─ Affiche miniature affiche

3. AnnouncementDetailScreen
   └─ Affiche affiche en grand
```

---

## 🛡️ Sécurité et Performance

### Sécurité

- ✅ **Validation MIME type** : Vérifie l'extension
- ✅ **Limite de taille** : Maximum 5 MB enforced
- ✅ **Validation Hive** : Type checking au runtime
- ✅ **Nettoyage orphelins** : Évite accumulation inutile

### Performance

- ✅ **Uint8List** : Format natif Flutter, optimisé
- ✅ **Image.memory()** : Pas de décodage fichier, rapide
- ✅ **Lazy loading** : Charge à la demande
- ✅ **Hive** : NoSQL rapide, performant < 50 MB

---

## 🐛 Dépannage

### Erreur: "Impossible de lire les données du fichier (Erreur Web)"

**Cause:** Navigateur n'a pas accès au fichier
**Solution:** Utilisez `file_picker: ^8.0.0+`

### Erreur: "Le fichier est trop volumineux"

**Cause:** Fichier > 5 MB
**Solution:** Compressez avant d'uploader (ImageMagick, etc.)

### Images floutées sur Web

**Cause:** Image trop grande ou mal encodée
**Solution:** Utilisez des JPG compressés (< 2 MB)

### Attachments qui disparaissent

**Cause:** Boîte Hive corrompue
**Solution:** Lancez `flutter clean` puis `flutter pub get`

---

## 📚 Exemples complets

Voir: [ATTACHMENT_INTEGRATION_GUIDE.dart](lib/ATTACHMENT_INTEGRATION_GUIDE.dart)
Voir: [USE_CASES_ATTACHMENTS.dart](lib/USE_CASES_ATTACHMENTS.dart)

---

## 🚀 Prochaines améliorations possibles

- [ ] Compression images automatique
- [ ] Support audio attachments
- [ ] Synchronisation cloud Attachment
- [ ] Historique versions attachments
- [ ] Annotations sur images (Sketchpad)
- [ ] Support vidéo (thumbnails)
- [ ] Backups automatiques

---

## 📞 Support

Pour les questions ou bugs :
1. Consultez [ATTACHMENT_INTEGRATION_GUIDE.dart](lib/ATTACHMENT_INTEGRATION_GUIDE.dart)
2. Consultez [USE_CASES_ATTACHMENTS.dart](lib/USE_CASES_ATTACHMENTS.dart)
3. Vérifiez les tests dans `test/` 

---

**Système créé : 2026-06-11** | **Version: 1.0.0-stable**
