// ============================================================================
// GUIDE D'INTÉGRATION COMPLÈTE - SYSTÈME D'ATTACHMENTS ECCLÉSIASTE
// ============================================================================

/*
 * STRUCTURE GÉNÉRALE:
 * 
 * 1. MODÈLES INTÉGRÉS ✅
 *    - AttachmentModel: Stockage binaire (Uint8List) Web-compatible
 *    - Event: Étendu avec dataAttachment
 *    - News: Étendu avec posterAttachment
 *
 * 2. SERVICES ✅
 *    - FileAttachmentService: Sélection et validation des fichiers
 *    - AttachmentStorageService: Gestion Hive + nettoyage orphelins
 *
 * 3. WIDGETS ✅
 *    - AttachmentPickerWidget: Sélection avec aperçu
 *    - AnnouncementCard: Affiche des annonces avec images
 *    - EventCardWithAttachment: Affiche des événements avec données
 *    - AnnouncementDetailScreen: Vue détaillée
 *    - AttachmentManagerScreen: Gestion administrateur
 *
 * 4. FORMULAIRES INTÉGRÉS ✅
 *    - SaisieProgrammePage: Création d'événements avec données
 *    - SimpleActionWizard: Assistant d'annonces avec affiche
 *    - CreateAnnouncementPage: Page dédiée pour annonces
 */

// ============================================================================
// EXEMPLE 1: UTILISER L'ATTACHMENTPICKERWIDGET DANS UN FORMULAIRE
// ============================================================================

import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/attachment_model.dart';
import 'package:ecclesiastes/widgets/attachment_picker_widget.dart';

class MyFormExample extends StatefulWidget {
  @override
  State<MyFormExample> createState() => _MyFormExampleState();
}

class _MyFormExampleState extends State<MyFormExample> {
  Attachment? _eventAttachment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Les autres champs du formulaire...

        // Widget d'attachement
        AttachmentPickerWidget(
          contextType: 'event', // ou 'announcement'
          initialAttachment: _eventAttachment,
          onAttachmentChanged: (attachment) {
            setState(() => _eventAttachment = attachment);
          },
          customLabel: 'Ajouter les données d\'événement\n(CSV, Excel, PDF)',
        ),

        // Bouton de sauvegarde
        ElevatedButton(
          onPressed: () {
            if (_eventAttachment != null) {
              print('Fichier sélectionné: ${_eventAttachment!.fileName}');
              print('Taille: ${_eventAttachment!.fileSizeInMB} MB');
              print('Type: ${_eventAttachment!.mimeType}');
            }
            // Sauvegarder l'événement...
          },
          child: const Text('CRÉER L\'ÉVÉNEMENT'),
        ),
      ],
    );
  }
}

// ============================================================================
// EXEMPLE 2: SAUVEGARDER AVEC ATTACHMENTS DANS HIVE
// ============================================================================

import 'package:ecclesiastes/services/attachment_storage_service.dart';
import 'package:ecclesiastes/models/news_model.dart';
import 'package:uuid/uuid.dart';

Future<void> saveAnnouncementWithAttachment(
  String title,
  String content,
  Attachment? posterAttachment,
) async {
  final news = News(
    id: const Uuid().v4(),
    title: title,
    imageUrl: 'placeholder',
    content: content,
    date: DateTime.now(),
    posterAttachment: posterAttachment,
  );

  // Sauvegarde l'attachment ET l'annonce ensemble
  await AttachmentStorageService.saveAnnouncementWithAttachment(
    announcement: news,
    attachment: posterAttachment,
  );
}

// ============================================================================
// EXEMPLE 3: CHARGER ET AFFICHER UNE ANNONCE AVEC AFFICHE
// ============================================================================

import 'package:ecclesiastes/views/announcement_detail_screen.dart';

void showAnnouncementDetail(String newsId) {
  AttachmentStorageService.getAnnouncementWithAttachment(newsId).then((news) {
    if (news != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnnouncementDetailScreen(
            announcement: news,
            onEdit: () {
              // Édition...
            },
            onDelete: () {
              AttachmentStorageService.deleteAnnouncementWithAttachment(
                  newsId);
            },
          ),
        ),
      );
    }
  });
}

// ============================================================================
// EXEMPLE 4: AFFICHER UNE IMAGE D'ATTACHMENT DIRECTEMENT
// ============================================================================

if (attachment != null && attachment.isImage) {
  Image.memory(
    attachment.fileData,
    fit: BoxFit.cover,
    width: 300,
    height: 200,
  )
} else if (attachment != null) {
  // C'est un document
  Center(
    child: Column(
      children: [
        Icon(Icons.insert_drive_file, size: 48),
        Text(attachment.fileName),
        Text('${attachment.fileSizeInMB} MB'),
      ],
    ),
  )
}

// ============================================================================
// EXEMPLE 5: VALIDER LA TAILLE AVANT DE SAUVEGARDER
// ============================================================================

import 'package:ecclesiastes/services/file_attachment_service.dart';

if (!FileAttachmentService.isFileSizeValid(attachment.fileData)) {
  print('Fichier trop volumineux (max 5 MB)');
  return;
}

// ============================================================================
// EXEMPLE 6: NETTOYER LES ATTACHMENTS ORPHELINS (AU DÉMARRAGE)
// ============================================================================

import 'package:ecclesiastes/services/attachment_storage_service.dart';

// À appeler au démarrage de l'app
void initializeAttachmentCleanup() {
  AttachmentStorageService.cleanupOrphanedAttachments().then((_) {
    print('Attachments orphelins nettoyés');
  });
}

// ============================================================================
// EXEMPLE 7: OBTENIR L'ESPACE UTILISÉ PAR LES ATTACHMENTS
// ============================================================================

Future<void> checkAttachmentStorage() async {
  final sizeInMB =
      await AttachmentStorageService.getTotalAttachmentSizeInMB();
  print('Espace utilisé: $sizeInMB MB');

  if (sizeInMB > 100) {
    // Avertissement si > 100 MB
    print('⚠️ Les attachments occupent beaucoup d\'espace');
  }
}

// ============================================================================
// EXEMPLE 8: INTÉGRATION DANS IMPORT_EVENTS_PAGE (BONUS)
// ============================================================================

class EventImportWithAttachments {
  // Importer une liste d'événements avec attachments associés
  static Future<void> importWithDataFiles(List<Event> events) async {
    for (final event in events) {
      // Chaque événement peut avoir son attachment
      if (event.dataAttachment != null) {
        await AttachmentStorageService.saveEventWithAttachment(
          event: event,
          attachment: event.dataAttachment,
        );
      }
    }
  }
}

// ============================================================================
// LIMITES ET NOTES IMPORTANTES
// ============================================================================

/*
 * 1. TAILLE MAXIMALE: 5 MB par fichier
 *    - Raison: Hive fonctionne bien jusqu'à ~50 MB pour la boîte entière
 *    - Si > 5 MB: Stockez dans le système de fichiers + gardez l'ID en Hive
 *
 * 2. COMPATIBILITÉ WEB:
 *    - ✅ file_picker v8+ avec support `.bytes`
 *    - ❌ Pas d'accès direct aux fichiers système
 *    - ✅ Les données binaires fonctionnent partout (Web + Mobile)
 *
 * 3. TYPES MIME SUPPORTÉS:
 *    - Images: image/jpeg, image/png, application/pdf
 *    - Données: text/csv, application/vnd.ms-excel, ...
 *
 * 4. NETTOYAGE:
 *    - Appelez cleanupOrphanedAttachments() régulièrement
 *    - Supprime automatiquement les attachments non référencés
 *
 * 5. PERFORMANCE:
 *    - Les images grandes ralentissent le rendu
 *    - Comprimez avant d'uploader (recommandé < 3 MB)
 *    - Hive est rapide pour les petits fichiers (< 50 MB total)
 */


 # 📖 RÉSUMÉ COMPLET DE L'APPLICATION ECCLÉSIASTE

---

## 🎯 1. IDENTITÉ DE L'APPLICATION

**Nom** : Ecclésiaste  
**Version** : 1.0.0  
**Plateforme** : Flutter Web (Chrome) avec rendu CanvasKit  
**Base de données** : Hive (locale)  
**Navigation** : GoRouter  
**Langue** : Français (avec support i18n prévu)  
**Copyright** : © 2026 Église Néo-Apostolique - Champ Apostolique KSO

**Objectif principal** : Digitaliser et centraliser la gestion complète de l'Église Néo-Apostolique en RDC, depuis l'Internationale jusqu'au dernier membre d'une communauté locale.

---

##  2. CONTEXTE ECCLÉSIAL

L'application sert l'**Église Néo-Apostolique** structurée ainsi :

```
🌍 Église Internationale (unique)
   ├── 🇨🇩 Église Territoriale RDC OUEST
   │     └── ⛪ Champs Apostoliques (ex: KSO)
   │           └── 🏛️ 22 Districts
   │                 └── 🏘️ 180 Communautés
   └── 🇩 Église Territoriale RDC EST
         └── ⛪ Champs Apostoliques
               └── 🏛️ Districts
                     └── 🏘️ Communautés
```

**Champ de référence** : **KSO (Kinshasa Sud-Ouest)** avec ses données réelles extraites du PDF "Organigramme Jeunesse KSO" d'octobre 2023.

---

## 🏛️ 3. LES 5 ENTITÉS (Hiérarchie Géographique)

| Niveau | Entité | Quantité | Responsable type |
|--------|--------|----------|------------------|
| 1 | Église Internationale | 1 | Apôtre Patriarche |
| 2 | Église Territoriale | 2 (RDC Ouest, RDC Est) | Apôtre de District |
| 3 | Champ Apostolique | Plusieurs (ex: KSO) | Apôtre (Champ/CAA) |
| 4 | District | 22 (KSO) | Ancien |
| 5 | Communauté | 180 (KSO) | Prêtre |

**Principe** : Chaque entité est dirigée par un **ministre** (autorité spirituelle) assisté d'un **suppléant**.

---

## 👔 4. LES 14 RANGS MINISTÉRIELS (Autorité Spirituelle)

Ce sont eux qui **dirigent** l'Église. Du plus haut au plus bas :

| N° | Rang | Niveau | Rôle principal |
|----|------|--------|----------------|
| 1 | **Apôtre Patriarche** | Internationale | Direction mondiale |
| 2 | **Apôtre de District** | Territoriale | Supervision régionale |
| 3 | **Apôtre Responsable** | Champ | Gestion d'un grand secteur |
| 4 | **Apôtre (Champ/CAA)** | Champ | Responsable d'un champ |
| 5 | **Évêque** | District (centre ville) | Bien-être spirituel |
| 6 | **Ancien** | District | Administration spirituelle |
| 7 | **Lead** | Circonscription | Vérification des activités |
| 8 | **Berger** | Sous-district | Accompagnement pastoral |
| 9 | **Évangéliste** | Centre | Prédication et missions |
| 10 | **Prêtre** | Congrégation | Sacrements et Sainte-Cène |
| 11 | **Diacre** | Congrégation | Soutien au prêtre |
| 12 | **Sous-Diacre** | Congrégation | Tâches liturgiques |
| 13 | **Frère Chargé** | Congrégation | Tâches spécifiques |
| 14 | **Conductrice** | Congrégation | Services féminins |

> ✅ **Correction appliquée** : `Lead` remplace `Lude` (qui n'existait pas).

---

## 🎯 5. LES 12 COMMISSIONS (Organes Fonctionnels)

Elles **servent** l'Église sous l'autorité du ministère. Présentes à chaque niveau (Territoriale → Communauté).

| N° | Commission | Description |
|----|------------|-------------|
| 1 | **ECODIM** | École du Dimanche (enfants) |
| 2 | **ECONFI** | École de Confirmation (catéchumènes) |
| 3 | **Jeunesse** | Mixte et Féminine |
| 4 | **Papas** | Pères de famille |
| 5 | **Mamans** | Mères de famille |
| 6 | **Aînés** | 65+ ans et FM en retraite |
| 7 | **Musique** | Direction Technique + Orchestre (2 sous-commissions) |
| 8 | **Presse, Médias et Sonorisation** | Communication et technique |
| 9 | **Joseph d'Arimathée** | Les Piliers |
| 10 | **Sécurité et Protocole** | Ordre et sécurité |
| 11 | **Médicale** | Assistance sanitaire |
| 12 | **Construction** | Bâtiments et infrastructures |

> ✅ **Correction appliquée** : Econfi = **École de Confirmation** (et non Économie/Finances).

### ⚠️ La Double Subordination des Commissions

Chaque commission a **deux chefs** :
1. **Subordination verticale (ministérielle)** : Elle répond au Ministre responsable de l'entité (ex: la Commission Jeunesse de ANE répond au Prêtre de ANE).
2. **Subordination horizontale (fonctionnelle)** : Elle répond à son supérieur hiérarchique de commission (ex: Jeunesse ANE → Jeunesse District Ngomba → Jeunesse Champ KSO).

---

##  6. LES 3 PROFILS UTILISATEURS

| Profil | Rôle | Accès documentaire |
|--------|------|---------------------|
| 👔 **Ministre** | Dirige l'Église | Manuels ministériels, Pensée directrice, Rapports officiels, Liturgie |
| 🎓 **Formateur** | Enseigne dans une commission | Manuels formateur/apprenant de sa commission, Programmes |
| 👤 **Membre** | Fidèle simple | Cantiques, Pensées directrices, Bible, Annonces locales |

---

## 🌊 7. LES 3 FLUX VITAUX

### 📢 Flux 1 : ANNONCES (Descendant : Top-Down)
```
Internationale → Territoriale → Champ → District → Communauté → Membre
```
**Exemple** : Visite du Patriarche en RDC Ouest → Tous les membres de RDC Ouest sont notifiés.

### 📅 Flux 2 : ÉVÉNEMENTS/PROGRAMMES (Horizontal + Descendant)
Chaque entité et chaque commission a ses programmes :
- **Mensuels** (activités régulières)
- **Trimestriels** (bilans)
- **Annuels** (calendrier global)
- **Spéciaux** (événements ponctuels)

### 📊 Flux 3 : RAPPORTS (Ascendant : Bottom-Up)
```
Communauté → District → Champ → Territoriale → Internationale
```
Chaque niveau **consolide** les rapports du niveau inférieur avant transmission.

---

## 📋 8. LES 32 TYPES DE RAPPORTS

| Catégorie | Nombre | Exemples |
|-----------|--------|----------|
| **Ministériels** | 9 | Service Divin (200106), Visite Pastorale, Funérailles, Mariage, Baptême, Sainte-Cène, Sacristie, Ordination, Communion Fraternelle |
| **Commissions** | 13 | ECODIM, ECONFI, Jeunesse, Papas, Mamans, Aînés, Musique (x2), Presse, Joseph d'Arimathée, Sécurité, Médicale, Construction |
| **Consolidation** | 5 | Un par niveau d'entité (Communauté → Internationale) |
| **Spéciaux** | 5 | Collecte, Événement, Mensuel, Trimestriel, Annuel |

### Fréquences
- **Hebdomadaire** : Sacristie, Communauté
- **Mensuel** : Service Divin, la plupart des commissions
- **Trimestriel** : Econfi, Jeunesse, Construction, Champ, Territoriale
- **Annuel** : Internationale, Territoriale
- **Événementiel** : Visites, Funérailles, Mariages, Baptêmes, Collectes

---

## ️ 9. ARCHITECTURE TECHNIQUE

### Stack technique
- **Framework** : Flutter 3.44.1 (Dart 3.12.1)
- **Web Renderer** : CanvasKit (par défaut depuis Flutter 3.22)
- **Base de données locale** : Hive
- **Routing** : GoRouter
- **État** : Provider / Riverpod (ConsumerWidget utilisé)

### Structure du projet
```
ecclesiaste/
├── lib/
│   ├── main.dart                    # Point d'entrée + init Hive
│   ├── router/
│   │   └── app_router.dart          # Routes GoRouter
│   ├── models/
│   │   └── core/                    # Modèles modulaires
│   │       ├── enums.dart           # EntityLevel, MinistryRank, CommissionType, ReportType, ReportStatus
│   │       ├── report_template.dart # Modèle dynamique de rapport
│   │       └── report_instance.dart # Instance de rapport remplie
│   ├── services/
│   │   ├── report_service.dart      # CRUD des rapports
│   │   ├── auth_service.dart        # Authentification
│   │   ├── data_loader_service.dart # Chargement JSON
│   │   └── universal_crud_service.dart # CRUD universel
│   ├── views/                       # 87 écrans
│   │   ├── welcome_page.dart        # Page d'accueil avec logo
│   │   ├── login_page.dart          # Connexion
│   │   ├── dashboard_page.dart      # Dashboard principal
│   │   ├── gestion_membres_page.dart
│   │   ├── report_list_screen.dart
│   │   ├── library_screen.dart
│   │   ├── bible_page.dart
│   │   ├── commissions_page.dart
│   │   ├── structure_test_page.dart # Affichage données KSO réelles
│   │   └── ... (80+ autres écrans)
│   └── widgets/                     # Composants réutilisables
└── assets/
    ├── logos/logo.png               # Logo unique de l'Église
    ├── data/                        # Données statiques JSON
    │   ├── ministeres/rangs.json    # 14 rangs
    │   ├── commissions/types.json   # 12 commissions
    │   ├── entities/                # 5 niveaux d'entités
    │   │   ├── champs/kso.json      # Données réelles KSO
    │   │   └── districts/ngomba_kinkusa.json
    │   └── members/                 # Membres par communauté
    ├── documents/                   # Fichiers PDF/statiques
    │   ├── ministeres/              # Manuels ministériels
    │   ├── commissions/             # Manuels par commission
    │   ├── liturgie/sacristie/      # Rituels
    │   └── rapports/templates/      # 5 modèles de rapports JSON
    ├── library/                     # Bible, Cantiques, Catéchisme
    └── flux/                        # Données dynamiques
        ├── internationale/
        ├── territoriale/
        ├── champs/kso/
        ├── districts/
        └── communautes/
```

---

## 📱 10. LES 87 ÉCRANS (Répartition)

| Catégorie | Nombre d'écrans | Exemples |
|-----------|-----------------|----------|
| **Authentification** | 4 | Login, Register, ForgotPassword, LegalDisclaimer |
| **Dashboards** | 6 | Main, Entity, Commission, Minister, Member, SuperAdmin |
| **Organisation** | 3 | Overview, Hierarchie, Organigramme |
| **Membres** | 8 | Liste, Détail, Inscription, Transfert, QR, Profil |
| **Rapports** | 12 | Liste, Création, Service Divin, Sacristie, Funérailles, Collecte, Validation, PDF, Archive, Export, Comparaison, Détail |
| **Annonces** | 6 | Liste, Création, Détail, Édition, Publication, Partage |
| **Bibliothèque** | 8 | Accueil, Cantiques, Catéchisme, Pensée Directrice, Liturgie, Programmes, Formations, Bible |
| **Événements** | 8 | Calendrier, Liste, Création, Détail, Import, Programme, Rappels, Historique |
| **Commissions** | 15 | Liste, Détail, Membres, Rapport + 11 écrans spécifiques |
| **Administration** | 7 | Utilisateurs, Rôles, Audit, Territoire, Districts, Settings, Profile |
| **Autres** | 10 | About, News, Signature, Wizard, etc. |

---

## 📊 11. DONNÉES RÉELLES DU KSO (Intégrées)

### Coordination Jeunesse KSO (8 membres)
- **Prêtre Didier KUYINDAMA** - Coordonnateur (0821699113)
- **Recteur Bernard MBENZA** - Coord. Adj. Spiritualité
- **Sœur Caroline LUSIMBA** - Coord. Adj. Jeunesse Féminine
- **Frère Anderson KAVUNGA** - Rapporteur & Administration
- **Prêtre Givenchy MAYAMBA** - Communication et Presse
- **Prêtre Christian NKUNGI** - Formation et Suppléant
- **Sœur Walburge TOMENE** - Caisse et Finances
- **Frère Jordan MANYAY** - Informatique (IT)

### 3 Pools
- **Pool 1** (7 districts) : Ngomba Kinkusa, UPN, Kanga Motema, Djelo Binza, Kerith, Bileko, Sarepta
- **Pool 2** (8 districts) : Sanga-Mamba, Malueka, Tshikapa, Kimbuala, Ebènezer, Mobatisi, Lutendele, Ngombi
- **Pool 3** (7 districts) : Météo, Munganga, Pompage, Mbudi, Mfinda, Binza, Manenga

### Exemple : District Ngomba Kinkusa (9 communautés)
ANE, Buania, Manassé, Sunem, Telecom, Kundey, Libanga, Peniel, Guhon

---

## 🔐 12. COMPTE SUPER ADMIN

| Champ | Valeur |
|-------|--------|
| **Email** | `superadmin@ecclesiastes.rdc` |
| **Mot de passe** | `Admin@2026!RDC` |

Le Super Admin peut **naviguer dans toutes les entités**, **ajouter/modifier/supprimer** entités, commissions, activités et rapports.

---

## ✅ 13. ÉTAT ACTUEL DU PROJET

### ✅ Réalisé
- [x] Structure Flutter complète avec 87 écrans
- [x] Base de données Hive fonctionnelle
- [x] 22 districts et 180 communautés du KSO intégrés
- [x] 14 rangs ministériels (avec correction `Lead`)
- [x] 12 commissions (avec correction `Econfi`)
- [x] Page d'accueil avec logo `logo_accueil.png`
- [x] Système de routing GoRouter
- [x] 5 modèles de rapports JSON (Service Divin, Visite, Commission, Collecte, Consolidation)
- [x] Modèles Dart modulaires (`ReportTemplate`, `ReportInstance`)
- [x] Service de gestion des rapports avec workflow de validation
- [x] Dashboard Super Admin avec navigation hiérarchique
- [x] Écran de test affichant les données réelles KSO
- [x] Structure complète des assets (data, documents, library, flux)
- [x] Application compilée et lancée sur Chrome

###  En cours / À finaliser
- [ ] Peupler les 22 districts avec toutes les communautés du PDF
- [ ] Écran de validation hiérarchique des rapports
- [ ] Écran de consolidation automatique (bottom-up)
- [ ] Système de notifications pour rapports en attente
- [ ] Module PDF pour exporter les rapports
- [ ] Intégration complète des 12 commissions dans chaque entité
- [ ] Gestion des membres par communauté
- [ ] Bibliothèque complète (Bible, Cantiques, Catéchisme)
- [ ] Filtre des documents par profil (Ministre/Formateur/Membre)
- [ ] Flux descendant des annonces (Internationale → Membre)
- [ ] Chiffrement des mots de passe pour la production

---

## 🎯 14. VISION FINALE

L'application **Ecclésiaste** sera le **système nerveux numérique** de l'Église Néo-Apostolique :

- 📱 **Pour le membre** : Un accès à sa communauté, aux annonces, à la Bible, aux cantiques
-  **Pour le formateur** : Des manuels, des programmes, des rapports de commission
- 👔 **Pour le ministre** : Des rapports officiels, une vue consolidée de son entité, des outils de gestion
-  **Pour le Super Admin** : Une vision complète de l'Église, de l'Internationale à la dernière communauté

**Le flux d'information descend** (annonces, programmes) **et les rapports remontent** (activités, consolidations), créant un écosystème vivant et connecté.

---

**🕊️ L'application est vivante. La structure est en place. seul Les données réelles du KSO sont intégrées pour l instant. Il ne reste plus qu'à peupler, connecter et polir !**

// ============================================================================
// FIN DU GUIDE
// ============================================================================
