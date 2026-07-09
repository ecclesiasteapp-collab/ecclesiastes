import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../domain/entities/library_document.dart';
import '../../domain/entities/ecclesiastical_entity.dart';

class ERPLibraryPage extends ConsumerWidget {
  const ERPLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mandates = ref.watch(activeMandatesProvider);
    final userLevel = ref.watch(userMaxLevelProvider);
    final getDocsUseCase = ref.watch(getLibraryDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque Numérique'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(context, ref),
        child: const Icon(Icons.add_a_photo),
      ),
      body: FutureBuilder<List<LibraryDocument>>(
        future: getDocsUseCase.execute(userMandates: mandates, userMaxLevel: userLevel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final docs = snapshot.data ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('Aucun document disponible pour votre niveau.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(doc.title),
                  subtitle: Text(doc.description),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    // Logic to open or download
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUploadDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dépôt de Document'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titre')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 16),
              const Text("Sélectionnez le niveau d'accès min :"),
              // Hierarchical levels would go here (Dropdown)
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final uploadUseCase = ref.read(uploadLibraryDocumentProvider);
              await uploadUseCase.execute(
                title: titleController.text,
                description: descController.text,
                type: DocumentType.manual,
                fileUrl: 'local://mock_path.pdf',
                allowedRoles: ['PASTOR'],
                minimumLevel: EntityLevel.communaute,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
              // Trigger refresh (usually done via a provider refresh)
            },
            child: const Text('PUBLIER'),
          ),
        ],
      ),
    );
  }
}
