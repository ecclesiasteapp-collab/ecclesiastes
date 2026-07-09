import 'package:flutter/material.dart';
import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:ecclesiaste/widgets/attachment_picker_widget.dart';
import 'package:ecclesiaste/services/attachment_storage_service.dart';
import 'dart:typed_data';

/// Page de test du système d'attachments
class AttachmentTestPage extends StatefulWidget {
  const AttachmentTestPage({super.key});

  @override
  State<AttachmentTestPage> createState() => _AttachmentTestPageState();
}

class _AttachmentTestPageState extends State<AttachmentTestPage> {
  Attachment? _eventAttachment;
  Attachment? _announcementAttachment;
  String _testLog = '';
  bool _isRunningTests = false;

  void _addLog(String message) {
    setState(() {
      _testLog = '$message\n$_testLog';
    });
  }

  Future<void> _runAllTests() async {
    setState(() => _isRunningTests = true);
    _testLog = '';
    _addLog('🧪 Tests en cours...');

    try {
      // Test 1: Créer un attachment factice
      _addLog('✅ Test 1: Créer attachment image');
      final dummyImageData = Uint8List.fromList([1, 2, 3, 4, 5]);
      final imageAttachment = Attachment(
        id: 'test-image-1',
        fileName: 'test.jpg',
        mimeType: 'image/jpeg',
        relativePath: '',
        fileSize: dummyImageData.length,
        fileData: dummyImageData,
      );
      if (imageAttachment.isImage) _addLog('   isImage: OK');

      // Test 2: Vérifier isDocument
      _addLog('✅ Test 2: Créer attachment document');
      final csvAttachment = Attachment(
        id: 'test-csv-1',
        fileName: 'test.csv',
        mimeType: 'text/csv',
        relativePath: '',
        fileSize: 1024,
        fileData: Uint8List(1024),
      );
      if (csvAttachment.isDocument) _addLog('   isDocument: OK');

      // Test 3: Sauvegarder attachment
      _addLog('✅ Test 3: Sauvegarder attachment');
      await AttachmentStorageService.saveAttachment(
        imageAttachment.fileName,
        imageAttachment.mimeType,
        dummyImageData,
      );

      // Test 4: Charger attachment
      _addLog('✅ Test 4: Charger attachment');
      final loaded =
          await AttachmentStorageService.getAttachment('test-image-1');
      if (loaded != null) _addLog('   Chargement: OK');
      if (loaded?.fileName == 'test.jpg') _addLog('   Nom fichier: OK');

      // Test 5: Vérifier taille
      _addLog('✅ Test 5: Vérifier taille');
      final sizeInMB =
          await AttachmentStorageService.getTotalAttachmentSizeInMB();
      _addLog('   Espace utilisé: ${sizeInMB.toStringAsFixed(2)} MB');

      // Test 6: Lister tous les attachments
      _addLog('✅ Test 6: Lister tous attachments');
      final allAttachments =
          await AttachmentStorageService.getAllAttachments();
      _addLog('   Total: ${allAttachments.length} fichier(s)');

      // Test 7: Supprimer attachment
      _addLog('✅ Test 7: Supprimer attachment');
      await AttachmentStorageService.deleteAttachment('test-image-1');

      _addLog('✅✅✅ TOUS LES TESTS TERMINÉS! ✅✅✅');
    } catch (e) {
      _addLog('❌ ERREUR: $e');
    }

    setState(() => _isRunningTests = false);
  }

  void _clearLog() {
    setState(() => _testLog = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test d\'Attachments'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Boutons d'action
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunningTests ? null : _runAllTests,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Lancer tests'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearLog,
                  icon: const Icon(Icons.clear),
                  label: const Text('Effacer log'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Log des tests
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                _testLog.isEmpty ? '(Aucun test lancé)' : _testLog,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 11,
                  color: Colors.green,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Formulaire de test
            const Text(
              'Tester les widgets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text(
              'Sélectionnez les fichiers à tester',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Sélecteur événement
            const Text(
              'Données d\'événement:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AttachmentPickerWidget(
              contextType: 'event',
              initialAttachment: _eventAttachment,
              onAttachmentChanged: (attachment) {
                setState(() => _eventAttachment = attachment);
                if (attachment != null) {
                  _addLog(
                      '📁 Événement: ${attachment.fileName} (${attachment.fileSizeInMB} MB)');
                }
              },
            ),
            const SizedBox(height: 20),

            // Sélecteur annonce
            const Text(
              'Affiche d\'annonce:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AttachmentPickerWidget(
              contextType: 'announcement',
              initialAttachment: _announcementAttachment,
              onAttachmentChanged: (attachment) {
                setState(() => _announcementAttachment = attachment);
                if (attachment != null) {
                  _addLog(
                      '📁 Annonce: ${attachment.fileName} (${attachment.fileSizeInMB} MB)');
                }
              },
            ),
            const SizedBox(height: 20),

            // Afficher les détails si sélectionné
            if (_eventAttachment != null) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails - Événement',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nom: ${_eventAttachment!.fileName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Type: ${_eventAttachment!.mimeType}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Taille: ${_eventAttachment!.fileSizeInMB} MB',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'ID: ${_eventAttachment!.id}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_announcementAttachment != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails - Annonce',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nom: ${_announcementAttachment!.fileName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Type: ${_announcementAttachment!.mimeType}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Taille: ${_announcementAttachment!.fileSizeInMB} MB',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'ID: ${_announcementAttachment!.id}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

