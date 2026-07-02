# Note de prevention des erreurs Ecclesiaste

## Objectif

Cette note sert de garde-fou pour les prochains changements dans le projet `Ecclesiaste`.
Elle documente les erreurs observees dans le code et les regles a respecter pour ne pas les reintroduire.

## Erreurs corrigees

### 1. Import i18n incorrect

- Contexte: le projet genere ses fichiers de localisation dans `lib/l10n/`.
- Regle: ne pas importer `package:flutter_gen/gen_l10n/app_localizations.dart`.
- Bon import:

```dart
import 'package:ecclesiastes/l10n/app_localizations.dart';
```

- Verification: s'assurer que les fichiers generes existent bien dans `lib/l10n/`.
- Si besoin: lancer `flutter gen-l10n`.

### 2. API de partage obsolete

- Probleme: l'ancien style `Share.share(...)` et `Share.shareXFiles(...)` est deprecie.
- Regle: utiliser `SharePlus.instance.share(...)` avec `ShareParams`.
- Bon exemple texte:

```dart
await SharePlus.instance.share(
  ShareParams(
    text: message,
    subject: 'Sujet',
  ),
);
```

- Bon exemple fichier:

```dart
await SharePlus.instance.share(
  ShareParams(
    files: [XFile(file.path)],
    text: 'Contenu',
    subject: 'Sujet',
  ),
);
```

### 3. Export conditionnel web/mobile

- Le projet doit rester compatible Web.
- Regle: toute logique `dart:io` doit rester dans un fichier `io` isole via export conditionnel.
- Exemple correct:

```dart
export 'service_stub.dart'
    if (dart.library.io) 'service_io.dart';
```

- Consequence: ne jamais importer `dart:io` dans un ecran ou un fichier partage par le graphe Web.

## Checklist avant commit

- Lancer `flutter analyze` au minimum sur les fichiers modifies.
- Verifier les imports `l10n` et confirmer qu'ils pointent vers `lib/l10n/`.
- Remplacer toute nouvelle utilisation de `Share.share` ou `Share.shareXFiles`.
- Eviter d'ajouter `dart:io` dans `main.dart`, le routeur, les vues ou les services communs.
- Garder les correctifs petits et cibles quand l'arbre Git contient deja beaucoup de changements.

## Points de vigilance connus

- Les rapports `analyze*.txt` a la racine peuvent etre anciens et ne pas refleter l'etat reel du code.
- En cas de doute, privilegier une analyse ciblee sur les fichiers modifies avant une analyse globale.
- Le projet contient encore beaucoup de lints non bloquants. Ne pas melanger un nettoyage de style massif avec une correction fonctionnelle urgente.

## Fichiers de reference

- `l10n.yaml`
- `lib/l10n/app_localizations.dart`
- `lib/views/settings_page_enhanced.dart`
- `lib/services/export_service.dart`
- `lib/services/export_service_io.dart`
- `lib/services/social_share_service.dart`
