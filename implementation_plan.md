# Plan d'Analyse et de Correction de l'Application Ecclesiaste

Ce plan décrit les corrections et les améliorations à apporter à l'application Ecclesiaste pour résoudre les erreurs de compilation et intégrer correctement les rôles de "responsable" et "suppléant responsable" au niveau des entités et des commissions.

## User Review Required

> [!IMPORTANT]
> Les modifications prévues résoudront des erreurs critiques qui empêchent actuellement l'application de compiler, notamment l'utilisation du widget non défini `RadioGroup` et l'intégration incomplète des tableaux de bord pour les responsables d'entités et de commissions.

## Proposed Changes

---

### 1. Widgets & Vues (Résolution de `RadioGroup`)

#### [MODIFY] [dynamic_form_builder.dart](file:///c:/Users/nestormbuyi/AndroidStudioProjects/assets/gemini/ecclesiaste/lib/widgets/dynamic_form_builder.dart)
Remplacer l'utilisation du widget fictif `RadioGroup` par un composant standard standard Flutter `Radio<String>` combiné avec un widget `Wrap` pour l'alignement et la gestion de l'état.

#### [MODIFY] [inscription_membre_page.dart](file:///c:/Users/nestormbuyi/AndroidStudioProjects/assets/gemini/ecclesiaste/lib/views/inscription_membre_page.dart)
1. Remplacer `RadioGroup` par le widget `Radio` natif de Flutter dans le widget de sélection radio personnalisé `_radio`.
2. Ajouter des listes déroulantes (Dropdowns) dans la section **"VI. SERVICE ET ENGAGEMENT"** pour permettre la sélection explicite des rôles d'entité (`_selectedEntityRole`) et de commission (`_selectedCommissionRole`) lors de l'inscription d'un membre.

---

### 2. Gestion de la Session et des Rôles

#### [MODIFY] [user_access.dart](file:///c:/Users/nestormbuyi/AndroidStudioProjects/assets/gemini/ecclesiaste/lib/utils/user_access.dart)
1. Mettre à jour `UserAccessProfile.current` pour détecter correctement le profil `responsableCommission` si l'utilisateur est responsable (`CommissionRole.responsable`) ou suppléant/adjoint (`CommissionRole.adjoint`).
2. Mettre à jour `UserAccessProfile.current` pour détecter correctement le profil `responsableEntite` si l'utilisateur a le rôle d'entité `'responsable'` ou `'suppleant'` dans son profil (permettant aux Deacons/Prêtres délégués à ces rôles d'avoir accès).
3. Adapter `UserAccessProfile.displayTitle` pour renvoyer dynamiquement `"Suppléant Responsable d'entité"` ou `"Suppléant Responsable de commission"` pour les adjoints/suppléants.

#### [MODIFY] [dashboard_page.dart](file:///c:/Users/nestormbuyi/AndroidStudioProjects/assets/gemini/ecclesiaste/lib/views/dashboard_page.dart)
Intégrer les redirections vers les bons tableaux de bord dans la méthode `build` :
1. Envoyer les utilisateurs ayant un rôle administratif global (`superAdmin`, `apotrePatriarche`, etc.) vers `MainDashboard`.
2. Envoyer les responsables et suppléants d'entité (`user.entityRole == 'responsable' / 'suppleant'`) vers `DashboardResponsableEntitePage`.
3. Envoyer les responsables et adjoints de commission (`user.commissionRole == CommissionRole.responsable / CommissionRole.adjoint`) vers `CommissionDashboard`.
4. Envoyer les membres standards vers `MemberDashboard`.
5. Envoyer le reste des ministres vers `MinisterDashboard`.

---

### 3. Nettoyage de Code & Navigation

#### [MODIFY] [custom_drawer.dart](file:///c:/Users/nestormbuyi/AndroidStudioProjects/assets/gemini/ecclesiaste/lib/widgets/custom_drawer.dart)
Remplacer la propriété dépréciée/supprimée `GoRouterState.of(context).location` par `GoRouterState.of(context).matchedLocation` pour assurer la pérennité du routage.

## Verification Plan

### Automated Tests
- N/A (le dossier de tests existant `test/` ne contient aucun fichier de test valide).

### Manual Verification
- Compiler l'application localement.
- Se connecter avec différents comptes de test (Super Admin, Responsable d'entité, Suppléant d'entité, Responsable de commission, Adjoint de commission) et vérifier qu'ils sont redirigés vers leurs tableaux de bord respectifs avec les libellés corrects.
- Ouvrir le formulaire d'inscription de membre et vérifier que la photo, la capture et les champs de rôles fonctionnent et s'enregistrent correctement.
