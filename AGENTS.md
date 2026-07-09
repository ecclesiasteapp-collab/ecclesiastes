# Guide de Développement pour l'Application Ecclesiaste

Ce document sert de guide technique pour tout développeur (humain ou IA) souhaitant contribuer au projet Ecclesiaste. Il décrit la structure du projet, les technologies clés, les principes de développement, les optimisations de performance déjà implémentées et les directives de contribution.

## 1. Introduction

L'application Ecclesiaste est une plateforme de gestion pour l'Église Néo-Apostolique. Elle est développée avec Flutter et utilise Hive pour la persistance des données locales. L'objectif de ce guide est d'assurer la cohérence du code, la maintenabilité et des performances optimales.

## 2. Structure du Projet

Le projet suit une structure modulaire typique des applications Flutter, avec une organisation claire des responsabilités :

-   `lib/`
    -   `config/`: Configuration globale et **Registre des Rapports** (`report_registry.dart`).
    -   `core/`: Classes fondamentales et transversales (thèmes, constantes).
    -   `models/`: Modèles de données (User, Hierarchy, News, Reports).
    -   `services/`: Services (Auth, Database, Navigation, Entité Scope).
    -   `utils/`: Utilitaires (Formatage, Sécurité, Enums).
    -   `views/`: Écrans organisés par dossiers (dashboards, reports, organization).
    -   `widgets/`: Composants UI réutilisables (Dashboards modulaires, Logo ENA).

## 3. Architecture Multi-Entités (5 Niveaux)

L'application repose sur une structure hiérarchique stricte de 5 niveaux, permettant une gestion granulaire et une agrégation des données du local vers l'international.

### 3.1. Les Niveaux Hiérarchiques
1.  **Internationale** : Sommet de la pyramide (unique).
2.  **Territoriale** : Églises Territoriales (ex: RDC Ouest).
3.  **Champ** : Zones de supervision apostolique.
4.  **District** : Regroupements de communautés.
5.  **Communauté** : Niveau local d'activité.

### 3.2. Principes Visuels
-   **Couleurs Institutionnelles** : Utiliser exclusivement le Bleu (#1B6B9E) et le Blanc.
-   **Fil d'Ariane (Boussole)** : Toujours situer l'utilisateur dans les 5 niveaux pour garantir la clarté du périmètre (scope).

## 4. Système de Rapports Universel

L'application dispose d'un moteur de rapports dynamique basé sur `UniversalReportScreen`.

### 4.1. Configuration des Rapports
Tous les rapports sont définis dans `lib/config/report_registry.dart`. Chaque configuration (`ReportConfig`) inclut :
-   Des **KPIs** (indicateurs clés de performance).
-   Des **Fields** (champs de saisie : texte, nombre, dropdown, checkbox, signature).
-   Des **Recommandations** et références à la bibliothèque.

### 4.2. Dynamisme Hiérarchique
Les rapports utilisent désormais `DatabaseHelper.getChaineAncestres()` pour résoudre et afficher les noms réels des entités (Champ, District, Communauté) en fonction de l'utilisateur connecté, supprimant ainsi les données codées en dur.

## 5. Paramètres et Persistance Avancée

L'application intègre une gestion complète des préférences utilisateur via `SettingsPageEnhanced`.

### 5.1. Modèle AppSettings
Le modèle a été étendu pour persister :
-   **Sécurité** : Biométrie, dernier changement de mot de passe.
-   **Notifications** : Activation granulaire (Push, Email, SMS).
-   **Accessibilité** : Taille de police (small à xlarge), contraste élevé, mode compact.
-   **Apparence** : Mode sombre, couleurs de thème dynamiques.
-   **Sauvegarde** : Auto-sauvegarde et historique des backups.

## 6. Technologies Clés

-   **Flutter** : Framework UI.
-   **Hive** : Persistance NoSQL locale.
-   **GoRouter** : Navigation déclarative.
-   **flutter_secure_storage** : Stockage sécurisé.
-   **fl_chart** : Visualisations de données.

## 7. Optimisations de Performance

-   **Réduction des Rebuilds** : Utilisation de `const`, extraction de sous-widgets et gestion d'état localisée.
-   **Lazy Loading** : Utilisation de `ListView.builder` pour les listes et carrousels.
-   **Cache Hive** : Centralisation des accès via `DatabaseHelper` et mise en cache des requêtes fréquentes.

## 8. Architecture de Données (Pattern Repository)

Pour garantir une compatibilité multiplateforme (Mobile/Web) robuste, une séparation claire des responsabilités et une meilleure testabilité, le projet adopte le **Pattern Repository**.

### 8.1. Principe
La logique métier (dans les vues ou les services de haut niveau) ne doit jamais accéder directement à une implémentation de stockage spécifique (ex: `dart:io`, `Hive`). Elle doit passer par une interface abstraite (un "Repository").

### 8.2. Exemples d'implémentation
-   **`AttachmentRepository`** : Gère le stockage des pièces jointes avec une implémentation pour le mobile (`dart:io`) et une pour le web (`Hive`).
-   **`NewsRepository`** : Gère les opérations CRUD pour les annonces, avec une implémentation unique (`HiveNewsRepository`) qui fonctionne sur toutes les plateformes.
-   **Injection via Riverpod** : `lib/providers/repository_providers.dart` fournit la bonne implémentation en fonction de la plateforme (`kIsWeb`).

## 9. Compatibilité Web

-   **Aucun `dart:io` dans le graphe Web** : Tout fichier importé par `main.dart`, le routeur ou un écran accessible sur Chrome doit éviter `dart:io`.
-   **Plugins mobiles isolés** : Les intégrations comme `workmanager` doivent passer par des exports conditionnels `stub` / `io`.
-   **Import de fichiers sur navigateur** : Utiliser `FilePicker` avec lecture en mémoire (`bytes`) plutôt que des chemins locaux.
-   **Abstraction du stockage** : Utiliser le Pattern Repository (voir section 8) pour gérer les accès aux données qui diffèrent entre le mobile et le web.

## 10. Stratégie de Test

Pour garantir la stabilité et la maintenabilité du projet, l'écriture de tests automatisés est une priorité.

### 10.1. Tests Unitaires
-   **Objectif** : Valider la logique métier isolée (services, repositories, modèles).
-   **Outils** : `flutter_test`.
-   **Principe** : Les tests de repositories doivent utiliser une version de Hive en mémoire (`Hive.init('memory')`) pour garantir des exécutions rapides et sans effets de bord.
-   **Exemple** : `test/attachment_repository_test.dart` est le premier test de référence pour cette approche.

## 11. Contribution

Avant de soumettre des modifications :
1.  **Vérifier le Registre** : Pour tout nouveau rapport, l'ajouter d'abord dans `report_registry.dart`.
2.  **Harmoniser l'UI** : Utiliser les composants du dossier `widgets/dashboard/`.
3.  **Utiliser les Repositories** : Pour toute nouvelle fonctionnalité nécessitant un accès au stockage (fichiers, base de données), utiliser ou créer un Repository approprié pour garantir la compatibilité multiplateforme.
4.  **Tester la Navigation** : Vérifier que les redirections de rôle dans `dashboard_page.dart` fonctionnent.
5.  **Mettre à Jour le Guide Markdown** : Reporter les correctifs de lancement et les décisions techniques importantes dans la documentation du projet.
6.  **Écrire des Tests** : Ajouter des tests unitaires pour toute nouvelle logique métier, en particulier pour les Repositories.

---
## 12. Historique des Modifications Récentes

### Juin 2026 - Transition Multi-Entités & Fonctionnalités Avancées

- **Architecture Multi-Entités** :
    - **Seeding Dynamique** : Refonte du `HierarchySeedService` pour utiliser `hierarchy_init.json` et `IdGenerator` (UUID), permettant d'initialiser n'importe quel territoire sans code en dur.
    - **Unicité Racine** : Mise en place d'une contrainte dans `DatabaseHelper` interdisant la création de plusieurs entités de type "Internationale".
    - **Rapports Dynamiques** : Mise à jour de `UniversalMonthlyReportScreen` pour afficher les noms réels des entités via la chaîne d'ancêtres.
- **Paramètres & Internationalisation (i18n)** :
    - **Internationalisation** : Mise en place complète du système `l10n` avec support du **Lingala** (app_ln.arb) et préparation pour les autres langues locales.
    - **Routeur** : Basculement de la navigation vers `SettingsPageEnhanced`.
    - **Persistance** : Extension du modèle `AppSettings` avec 17 champs persistés (Accessibilité, Notifications, Sauvegarde, Sécurité).
- **Logique Métier & Sécurité** :
    - **Export RGPD** : Finalisation du `ExportService` avec gestion sécurisée des types Hive et intégration dans l'UI.
    - **Nettoyage Technique** : Correction des erreurs d'imports, harmonisation de l'internationalisation (i18n) dans les paramètres et suppression des avertissements de compilation.
    - **Bible TOB** : Intégration complète du fichier `assets/librairie/bible_tob.json` avec notes chiffrées et partage brandé.
- **Architecture de Données** :
    - Mise en place du pattern Repository pour l'accès aux données (`AttachmentRepository`).
    - Généralisation du pattern aux autres modèles de données (ex: `NewsRepository`).
    - Injection de dépendances via Riverpod pour fournir la bonne implémentation selon la plateforme.
    - Nettoyage et simplification de l'initialisation de la base de données (`DatabaseService`).
- **Qualité et Stabilité** :
    - Introduction des tests unitaires pour les repositories avec une initialisation de Hive en mémoire.

---
## 13. Correctifs de Compatibilité Web (Juin 2026)

L'application a subi une série de corrections majeures pour garantir son exécution sur Chrome :
1.  **Initialisation Hive** : Adaptation de `DatabaseService` pour ne plus appeler `path_provider` sur le Web.
2.  **Exports Conditionnels** : Isolation de `dart:io` via des stubs pour `ExportService`, `FileStorageService` et `Workmanager`.
3.  **Stockage Web** : Implémentation réelle du stockage dans `file_storage_service_stub.dart` utilisant une box Hive dédiée (`web_file_storage_box`) pour persister les octets (signatures, images) sur le navigateur.
4.  **Dynamisation des Rapports et Inscriptions** : Suppression des données "hardcoded" dans les formulaires (`CreateReportScreen`, `FundraisingReportScreen`). La `RegisterPage` charge désormais les vrais Champs, Districts et Communautés depuis la base de données locale via `DatabaseHelper`.

### Juillet 2026 - Migration Architecture Repository, Tests & ERP

- **Généralisation du Pattern Repository** :
    - Migration complète des modules **Annonces**, **Membres**, **Finances** et **Rapports** vers des Repositories abstraits.
    - Utilisation systématique de `HiveNewsRepository`, `HiveMemberRepository`, `HiveFinanceRepository` et `HiveReportRepository`.
    - Injection de dépendances via **Riverpod** (`repository_providers.dart`) pour une compatibilité Mobile/Web native.
- **Module ERP & Consolidation** :
    - Création du UseCase **`ConsolidateFinance`** pour agréger récursivement les données financières à travers la hiérarchie.
    - Mise en place du **`activeEntityIdProvider`** permettant au Hub ERP et aux statistiques de se rafraîchir dynamiquement lors d'un changement de scope.
    - Intégration des "Pills" hiérarchiques dans le Hub Ecclésiaste pour une navigation granulaire.
- **Statistiques Dynamiques** :
    - Refonte du `PastoralAnalyticsService` pour utiliser les Repositories au lieu d'accès Hive directs.
    - Intégration asynchrone dans `PastoralStatisticsScreen` avec gestion du scope à 6 niveaux.
- **Qualité & Stabilité** :
    - Mise en place d'une suite de **tests unitaires** pour tous les repositories (`test/*.dart`).
    - Utilisation de Hive en mémoire pour l'isolation des tests (11 tests validés).
    - Activation de la couverture de tests (`flutter test --coverage`).
- **Alignement Hiérarchique** :
    - Extension du modèle `MemberProfile` pour supporter la chaîne complète des 6 niveaux (Internationale, Territoriale, Région, Champ, District, Communauté).
    - Mise à jour du `InscriptionMembreStepper` pour capturer ces métadonnées dynamiquement.

*Dernière mise à jour : 10 Juillet 2026*
 