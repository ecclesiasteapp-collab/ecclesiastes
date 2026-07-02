# Note de Migration : Évolution du Modèle `SyncQueueItem`

**Date** : 29 Juin 2026  
**Modèle concerné** : `lib/models/sync_queue_model.dart`  
**Adaptateur modifié** : `lib/models/sync_queue_model.g.dart`

---

## 1. Contexte du Changement

Le modèle de données `SyncQueueItem` a été mis à jour pour inclure un nouveau champ :

```dart
@HiveField(8)
String priority; // ex: 'normal', 'high'
```

Ce champ a été ajouté pour permettre de prioriser certaines actions de synchronisation par rapport à d'autres.

## 2. Problématique de la Migration

Une simple régénération de l'adaptateur Hive via `build_runner` aurait rendu l'application incapable de lire les anciennes données stockées sur les appareils des utilisateurs. En effet, l'ancien adaptateur s'attendait à lire 8 champs, alors que le nouveau en aurait attendu 9, provoquant une erreur de désérialisation et un crash potentiel.

Pour garantir la **rétrocompatibilité**, l'adaptateur généré (`sync_queue_model.g.dart`) a été modifié manuellement.

## 3. Modifications Manuelles de l'Adaptateur

Voici les changements appliqués au fichier `lib/models/sync_queue_model.g.dart` :

```diff
--- a/lib/models/sync_queue_model.g.dart
+++ b/lib/models/sync_queue_model.g.dart
@@ -16,13 +16,15 @@
     return SyncQueueItem(
       id: fields as String,
       actionType: fields as String,
       payloadJson: fields as String,
       createdAt: fields as DateTime,
       isSynced: fields as bool,
       status: fields as String,
       retryCount: fields as int,
       errorMessage: fields as String?,
+      // Si le champ 8 (priority) n'existe pas, on lui donne une valeur par défaut.
+      priority: fields as String? ?? 'normal',
     );
   }
 
   @override
   void write(BinaryWriter writer, SyncQueueItem obj) {
     writer
-      ..writeByte(8)
+      // On indique qu'on écrit maintenant 9 champs.
+      ..writeByte(9)
       ..writeByte(0)
       ..write(obj.id)
       ..writeByte(1)
@@ -37,7 +39,9 @@
       ..writeByte(6)
       ..write(obj.retryCount)
       ..writeByte(7)
-      ..write(obj.errorMessage);
+      ..write(obj.errorMessage)
+      ..writeByte(8)
+      ..write(obj.priority);
   }
 
   @override

```

### Logique de la méthode `read`

Lors de la lecture, l'expression `fields[8] as String? ?? 'normal'` gère les deux cas :
-   **Anciennes données** : Le champ `fields[8]` n'existe pas et est `null`. L'opérateur `??` assigne alors la valeur par défaut `'normal'`.
-   **Nouvelles données** : Le champ `fields[8]` existe et sa valeur est utilisée.

### Logique de la méthode `write`

-   Le nombre de champs écrits est passé de `8` à `9` (`writeByte(9)`).
-   La logique pour écrire le nouveau champ `priority` à l'index `8` a été ajoutée.

## 4. Avertissement Critique

⚠️ **NE PLUS UTILISER `build_runner` SUR CE MODÈLE** ⚠️

L'adaptateur `sync_queue_model.g.dart` est maintenant géré manuellement. Toute exécution de `flutter pub run build_runner build` écrasera cette logique de migration, réintroduisant le risque de corruption des données pour les utilisateurs existants. Toute future modification de ce modèle devra être accompagnée d'une mise à jour manuelle de cet adaptateur.