# Dashboard Modulaire pour Responsables de Commissions

## Vue d'ensemble

Le dashboard modulaire pour responsables et suppléants de commissions a été intégré dans le projet Ecclesiastes. Il adapte automatiquement son contenu et ses fonctionnalités selon le niveau d'entité de l'utilisateur (Internationale, Territoriale, Champ, District, Communauté).

## Architecture

### Fichiers principaux

#### 1. **Dashboard Principal**
- **Fichier** : `lib/views/dashboards/dashboard_commission_modulaire_page.dart`
- **Classe** : `DashboardCommissionModulairePage`
- **Description** : Page principale du dashboard avec tous les éléments visuels et la logique d'orchestration
- **Paramètres** :
  - `isSuppleant` : Booléen indiquant si l'utilisateur est suppléant (affiche les restrictions appropriées)

#### 2. **Widgets Réutilisables**

##### a) CommissionScopeTabs
- **Fichier** : `lib/widgets/dashboard/commission_scope_tabs.dart`
- **Classe** : `CommissionScopeTabs`
- **Description** : Onglets de sélection du niveau d'entité avec icônes
- **Propriétés** :
  - `selectedIndex` : Index de l'onglet sélectionné
  - `onChanged` : Callback lors du changement de sélection
  - `showAllLevels` : Affiche tous les niveaux ou seulement ceux accessibles
  - `userEntityLevel` : Niveau d'entité de l'utilisateur pour filtrer les onglets

##### b) CommissionInfoCard
- **Fichier** : `lib/widgets/dashboard/commission_info_card.dart`
- **Classe** : `CommissionInfoCard`
- **Description** : Carte d'information de la commission avec responsable/suppléant et statistiques
- **Propriétés** :
  - `commissionName` : Nom de la commission
  - `responsableName` : Nom du responsable principal
  - `suppléantName` : Nom du suppléant
  - `membersCount` : Nombre de membres
  - `districtsCount` : Nombre de districts
  - `communitiesCount` : Nombre de communautés
  - `entityLevel` : Niveau d'entité pour adapter le texte des statistiques
  - `isSuppleant` : Affiche un badge si l'utilisateur est suppléant

##### c) CommissionQuickActions
- **Fichier** : `lib/widgets/dashboard/commission_quick_actions.dart`
- **Classe** : `CommissionQuickActions`
- **Description** : Actions rapides contextuelles selon le niveau d'entité
- **Propriétés** :
  - `entityLevel` : Niveau d'entité pour adapter les actions disponibles
  - `isSuppleant` : Désactive certaines actions pour les suppléants
  - Callbacks pour chaque action (onNewReport, onCreateEvent, etc.)

### Niveaux d'entité et adaptation

Le dashboard s'adapte automatiquement selon le niveau d'entité de l'utilisateur :

| Niveau | Label | Actions disponibles | Statistiques |
|--------|-------|-------------------|--------------|
| **Internationale** | Église Internationale | Tous les rôles, gestion globale | Membres, Territoires, Champs |
| **Territoriale** | Église Territoriale | Gestion territoriale | Membres, Champs, Districts |
| **Champ** | Champ Apostolique | Gestion du champ | Membres, Districts, Communautés |
| **District** | District | Gestion du district | Membres, Communautés |
| **Communauté** | Communauté | Gestion locale | Membres actifs |

## Intégration

### 1. Routage

Le dashboard est automatiquement routé selon le rôle de l'utilisateur :

```dart
// Dans dashboard_page.dart
if (user.commissionRole == CommissionRole.responsable ||
    user.commissionRole == CommissionRole.adjoint) {
  return DashboardCommissionModulairePage(
    isSuppleant: user.commissionRole == CommissionRole.adjoint,
  );
}
```

### 2. Routes disponibles

- **Route principale** : `/dashboard` (dispatcher automatique)
- **Route directe** : `/dashboard/commission` (accès direct au dashboard modulaire)

### 3. Imports requis

```dart
import 'package:ecclesiastes/views/dashboards/dashboard_commission_modulaire_page.dart';
import 'package:ecclesiastes/widgets/dashboard/commission_scope_tabs.dart';
import 'package:ecclesiastes/widgets/dashboard/commission_info_card.dart';
import 'package:ecclesiastes/widgets/dashboard/commission_quick_actions.dart';
```

## Sections du Dashboard

### 1. **En-tête (AppBar)**
- Avatar de l'utilisateur avec initiales
- Titre adaptatif : "Resp. Commission [Nom]" ou "Suppl. Commission [Nom]"
- Sous-titre : Nom de l'église et nom complet de l'utilisateur
- Bouton notifications avec badge

### 2. **Sélecteur de Niveau d'Entité**
- Onglets horizontaux pour naviguer entre les niveaux
- Icônes visuelles pour chaque niveau
- Sélection persistante dans la session

### 3. **Carte d'Information de Commission**
- Informations du responsable et suppléant
- Statistiques adaptées au niveau d'entité
- Badge "Mode Suppléant Actif" si applicable

### 4. **À la Une (Carousel)**
- 4 annonces principales avec images
- Numérotation des articles
- Bouton "Lire" pour chaque article

### 5. **Navigation Rapide**
- Grille 2x2 d'accès rapide aux fonctionnalités
- Programmes, Rapports, Événements, Calendrier

### 6. **Actions Rapides**
- Actions contextuelles selon le niveau d'entité
- Désactivées pour les suppléants
- Icônes et couleurs distinctives

### 7. **Rapport Financier**
- Cotisations mensuelles
- Collectes spéciales
- Dons et parrainages
- Barres de progression par catégorie
- Total collecté

### 8. **Gestion des Commissions**
- Affichage du statut de la commission
- Progression de la gestion
- Bouton "Positionner"
- Option de fusion

### 9. **Équipe Internationale**
- Liste des membres de l'équipe
- Rôles et responsabilités
- Indicateurs de statut en ligne

### 10. **Autres Pages (Social Hub)**
- Notifications des réseaux sociaux
- Liens vers Facebook, Instagram, YouTube, etc.

## Personnalisation

### Adapter les données

Pour utiliser les données réelles de la base de données, modifiez la méthode `_load()` :

```dart
Future<void> _load() async {
  setState(() => _loading = true);
  
  final user = AuthService.currentUser;
  
  // Récupérer le niveau d'entité réel
  _userEntityLevel = user?.entityLevel ?? EntityLevel.communaute;
  
  // Récupérer les données de commission
  final commission = await DatabaseHelper.instance
      .getCommissionByType(user?.commissionType);
  
  // Récupérer les annonces
  final annonces = await DatabaseHelper.instance.getAnnoncesRecent();
  
  if (mounted) {
    setState(() {
      _commissionInfo = commission;
      _annonces = annonces;
      _loading = false;
    });
  }
}
```

### Ajouter des actions

Pour ajouter de nouvelles actions rapides, modifiez `CommissionQuickActions._getAvailableActions()` :

```dart
actions.add({
  'label': 'Ma Nouvelle Action',
  'icon': Icons.my_icon,
  'color': Colors.myColor,
  'onTap': onMyAction,
  'visible': !isSuppleant,
});
```

### Modifier les couleurs

Les couleurs sont définies en haut de chaque fichier :

```dart
const _bg = Color(0xFF0D1B3E);        // Fond principal
const _card = Color(0xFF1A2A4A);      // Cartes
const _accent = Color(0xFF0066CC);    // Accent
const _textSecondary = Colors.white70; // Texte secondaire
```

## Fonctionnalités avancées

### Filtrage par niveau d'entité

Le widget `CommissionScopeTabs` peut filtrer automatiquement les niveaux accessibles :

```dart
CommissionScopeTabs(
  selectedIndex: _selectedScopeIndex,
  onChanged: (index) => setState(() => _selectedScopeIndex = index),
  showAllLevels: false, // Affiche seulement les niveaux accessibles
  userEntityLevel: _userEntityLevel,
)
```

### Mode suppléant

Le dashboard affiche automatiquement les restrictions appropriées :

```dart
DashboardCommissionModulairePage(
  isSuppleant: true, // Active le mode suppléant
)
```

## Tests

### Points de test recommandés

1. **Navigation entre niveaux d'entité**
   - Vérifier que les onglets changent correctement
   - Vérifier que les statistiques s'adaptent

2. **Mode suppléant**
   - Vérifier que les actions sont désactivées
   - Vérifier que le badge s'affiche

3. **Responsive design**
   - Tester sur différentes tailles d'écran
   - Vérifier le scroll horizontal des onglets

4. **Données réelles**
   - Connecter à la base de données
   - Vérifier l'affichage des données réelles

## Dépannage

### Le dashboard n'apparaît pas

1. Vérifier que l'utilisateur a le rôle `CommissionRole.responsable` ou `CommissionRole.adjoint`
2. Vérifier que le dispatcher `dashboard_page.dart` est correctement configuré
3. Vérifier les logs pour les erreurs d'import

### Les actions ne répondent pas

1. Vérifier que les callbacks sont passés correctement
2. Vérifier que `isSuppleant` est défini correctement
3. Vérifier que le contexte est valide

### Les données ne s'affichent pas

1. Vérifier que `_load()` est appelé dans `initState()`
2. Vérifier que les requêtes à la base de données retournent des données
3. Vérifier que `setState()` est appelé correctement

## Améliorations futures

- [ ] Intégration complète avec la base de données
- [ ] Cache des données pour améliorer les performances
- [ ] Animations de transition entre les niveaux
- [ ] Graphiques de statistiques avancés
- [ ] Export des données en PDF/Excel
- [ ] Notifications en temps réel
- [ ] Synchronisation multi-appareils
- [ ] Mode hors ligne

## Support

Pour toute question ou problème, consultez :
- La documentation Flutter : https://flutter.dev/docs
- Le code source du projet : `/lib/views/dashboards/`
- Les widgets réutilisables : `/lib/widgets/dashboard/`
