import 'package:hive/hive.dart';
import 'sync_queue_model.dart';

/// Cet adaptateur personnalisé gère la lecture des anciennes versions
/// du modèle `SyncQueueItem` et écrit toujours la version la plus récente.
class SyncQueueItemMigratingAdapter extends TypeAdapter<SyncQueueItem> {
  @override
  final int typeId = 118; // Doit correspondre au typeId du modèle

  @override
  SyncQueueItem read(BinaryReader reader) {
    // La première information que nous lisons est le nombre de champs.
    // Cela nous sert de "numéro de version" implicite.
    final numOfFields = reader.readByte();

    // On lit les champs dans une Map pour un accès sécurisé.
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Ici se trouve la logique de migration.
    // On reconstruit l'objet en fournissant des valeurs par défaut pour les champs manquants.
    return SyncQueueItem(
      id: fields[0] as String,
      actionType: fields[1] as String,
      payloadJson: fields[2] as String,
      createdAt: fields[3] as DateTime,
      isSynced: fields[4] as bool? ?? false,
      status: fields[5] as String? ?? SyncStatus.pending,
      retryCount: fields[6] as int? ?? 0,
      // Le champ 7 (errorMessage) est ignoré à la lecture.
      // Si nous lisons une ancienne version (avec 8 champs ou moins),
      // le champ 'priority' (index 8) n'existera pas. On lui donne une valeur par défaut.
      priority: fields.containsKey(8) ? fields[8] as String : 'normal',
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueItem obj) {
    // La méthode `write` écrit TOUJOURS le modèle le plus récent.
    // Ici, nous déléguons l'écriture à l'adaptateur auto-généré,
    // qui est toujours à jour avec la dernière version du modèle.
    //
    // Pour que cela fonctionne, il faut que l'adaptateur généré soit accessible.
    // Nous allons supposer qu'il est généré par `sync_queue_model.g.dart`.
    // Note : L'adaptateur généré n'est pas public, nous devons donc réimplémenter la logique d'écriture.

    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.payloadJson)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isSynced)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(7) // Le champ 'priority' a été ajouté à l'index 8, mais on va l'écrire à l'index 7 pour la compatibilité.
      ..write(obj.priority);
  }
}
