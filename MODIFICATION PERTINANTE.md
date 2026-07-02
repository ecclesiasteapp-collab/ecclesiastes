# Plan d'Action : Transition vers une Architecture Multi-Entités

Ce plan détaille les étapes nécessaires pour transformer le projet **Ecclésiaste** d'une version centrée sur le "Champ KSO" vers une plateforme capable de gérer plusieurs églises territoriales, champs apostoliques, districts et communautés, tout en maintenant une Église Internationale unique.

---

## Phase 1 : Abstraction de la Hiérarchie et du Seeding
**Objectif** : Supprimer les données codées en dur et permettre l'initialisation de n'importe quel champ ou territoire.

| Étape | Description Technique | Fichiers Impactés | Délai Estime |
| :--- | :--- | :--- | :--- |
| **1.1** | Créer un modèle de données JSON pour la configuration initiale (remplaçant `kso_districts_config.dart`). | `assets/config/hierarchy_init.json` | 0.5 jour |
| **1.2** | Refondre `KsoSeedService` en `HierarchySeedService` pour lire le JSON et générer les entités dynamiquement. | `lib/services/hierarchy_seed_service.dart` | 1 jour |
| **1.3** | Mettre en place des générateurs d'IDs uniques (UUID) pour éviter les collisions entre différents champs. | `lib/utils/id_generator.dart` | 0.5 jour |

## Phase 2 : Extension du Système de Périmètre (Scope)
**Objectif** : Permettre à l'application de naviguer et de filtrer les données sur les 5 niveaux hiérarchiques.

| Étape | Description Technique | Fichiers Impactés | Délai Estime |
| :--- | :--- | :--- | :--- |
| **2.1** | Ajouter `territorialeId` et `internationaleId` au service de scope. | `lib/services/entite_scope_service.dart` | 0.5 jour |
| **2.2** | Améliorer la méthode `initFromCommunaute` pour reconstruire l'arbre complet (5 niveaux) via `DatabaseHelper`. | `lib/services/entite_scope_service.dart` | 0.5 jour |
| **2.3** | Créer un sélecteur d'entité global permettant aux administrateurs de haut niveau de changer de territoire ou de champ. | `lib/screens/navigation/entity_selector.dart` | 1 jour |

## Phase 3 : Sécurisation et Unicité de la Racine
**Objectif** : Garantir par le code que l'Église Internationale reste l'unique sommet de la pyramide.

| Étape | Description Technique | Fichiers Impactés | Délai Estime |
| :--- | :--- | :--- | :--- |
| **3.1** | Ajouter une contrainte de validation lors de la création d'entités pour interdire un deuxième type "Internationale". | `lib/services/database_helper.dart` | 0.5 jour |
| **3.2** | Mettre à jour les règles RBAC pour que seul le "Super Admin" puisse modifier les paramètres de l'Église Internationale. | `lib/core/rbac/admin_roles.dart` | 0.5 jour |

## Phase 4 : Généralisation de l'Interface Utilisateur (UI)
**Objectif** : Rendre les écrans dynamiques et indépendants du nom "KSO".

| Étape | Description Technique | Fichiers Impactés | Délai Estime |
| :--- | :--- | :--- | :--- |
| **4.1** | Transformer `KsoDashboardScreen` en `EntityDashboardScreen` utilisant les données du scope actif. | `lib/screens/champ/dashboard_screen.dart` | 1.5 jour |
| **4.2** | Remplacer les textes statiques par des variables issues de `OrganizationConfig` ou `TerritoryConfig`. | Tous les écrans `lib/screens/*` | 1 jour |

---

## Résumé des Délais
*   **Total estimé** : 8 jours de développement.
*   **Ordre de priorité** : Phase 1 & 2 sont critiques pour le fonctionnement multi-champs ; Phase 3 & 4 assurent la pérennité et l'expérience utilisateur.

> **Note** : Ce plan suppose que les modèles Hive existants (`EntityModel`) sont conservés car ils sont déjà suffisamment génériques pour supporter ces changements.
