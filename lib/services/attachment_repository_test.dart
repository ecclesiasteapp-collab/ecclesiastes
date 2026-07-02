import 'dart:typed_data';

import 'package:ecclesiastes/models/attachment_model.dart';
import 'package:ecclesiastes/services/web_attachment_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  group('WebAttachmentRepository Tests', () {
    // Avant de lancer les tests, on initialise une version "en mémoire" de Hive.
    // Cela permet aux tests de s'exécuter rapidement sans créer de vrais fichiers.
    setUpAll(() {
      Hive.init('memory');
    });

    // Après les tests, on nettoie les boîtes Hive pour ne pas affecter d'autres tests.
    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Sauvegarder et charger une pièce jointe fonctionne correctement', () async {
      // Arrange: Préparation du test
      final repository = WebAttachmentRepository();
      final testData = Uint8List.fromList([1, 2, 3, 4, 5]);
      const fileName = 'test.jpg';

      // Act: Exécution de l'action à tester
      final storageKey = await repository.saveAttachmentData(testData, fileName);

      // Assert: Vérification du résultat
      expect(storageKey, isNotNull);
      expect(storageKey.contains(fileName), isTrue);

      // Arrange (pour le chargement)
      final attachmentToLoad = Attachment(
        id: 'test-id',
        fileName: fileName,
        mimeType: 'image/jpeg',
        relativePath: storageKey, // On utilise la clé retournée par la sauvegarde
        fileSize: testData.length,
      );

      // Act (chargement)
      final loadedData = await repository.loadAttachmentData(attachmentToLoad);

      // Assert (chargement)
      expect(loadedData, equals(testData));
    });
  });
}
