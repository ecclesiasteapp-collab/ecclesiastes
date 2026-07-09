import 'package:flutter/material.dart';
import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:ecclesiaste/services/attachment_storage_service.dart';

class AttachmentManagerScreen extends StatefulWidget {
  const AttachmentManagerScreen({super.key});

  @override
  State<AttachmentManagerScreen> createState() =>
      _AttachmentManagerScreenState();
}

class _AttachmentManagerScreenState extends State<AttachmentManagerScreen> {
  List<Attachment> _attachments = [];
  bool _isLoading = true;
  double _totalSizeInMB = 0;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    setState(() => _isLoading = true);
    try {
      final attachments =
          await AttachmentStorageService.getAllAttachments();
      final sizeInMB =
          await AttachmentStorageService.getTotalAttachmentSizeInMB();

      setState(() {
        _attachments = attachments;
        _totalSizeInMB = sizeInMB;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAttachment(String id) async {
    try {
      await AttachmentStorageService.deleteAttachment(id);
      await _loadAttachments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pièce jointe supprimée'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _cleanupOrphaned() async {
    try {
      await AttachmentStorageService.cleanupOrphanedAttachments();
      await _loadAttachments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Nettoyage des pièces jointes orphelines terminé'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionnaire de Pièces Jointes'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttachments,
            tooltip: 'Rafraîchir',
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _cleanupOrphaned,
            tooltip: 'Nettoyer les orphelines',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistiques
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total des pièces jointes',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_attachments.length} fichier(s)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003366),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Espace utilisé',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_totalSizeInMB.toStringAsFixed(2)} MB',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003366),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Liste
                Expanded(
                  child: _attachments.isEmpty
                      ? const Center(
                          child: Text('Aucune pièce jointe'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _attachments.length,
                          itemBuilder: (context, index) {
                            final attachment = _attachments[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: Icon(
                                  attachment.isImage
                                      ? Icons.image
                                      : Icons.insert_drive_file,
                                  color: attachment.isImage
                                      ? Colors.orange
                                      : Colors.blue,
                                ),
                                title: Text(
                                  attachment.fileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${attachment.fileSizeInMB} MB • ${attachment.mimeType}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Supprimer'),
                                        content: const Text(
                                          'Supprimer cette pièce jointe ?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _deleteAttachment(
                                                  attachment.id);
                                            },
                                            child: const Text('Supprimer',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

