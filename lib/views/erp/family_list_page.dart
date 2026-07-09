import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';

class ERPFamilyListPage extends ConsumerWidget {
  const ERPFamilyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familiesAsync = ref.watch(familiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Familles"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFamilyDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: familiesAsync.when(
        data: (families) => families.isEmpty
            ? const Center(child: Text("Aucune famille enregistrée."))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: families.length,
                itemBuilder: (context, index) {
                  final family = families[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.home, color: Theme.of(context).primaryColor),
                      title: Text(family.name),
                      subtitle: Text("${family.memberIds.length} membres • ${family.address}"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // View family details
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  void _showCreateFamilyDialog(BuildContext context, WidgetRef ref) {
    // Logic to select head of family and members from the entity
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fonctionnalité de création en cours..."))
    );
  }
}
