// lib/views/admin/assignation_responsables_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';
import '../../models/district_model.dart';
import '../../services/entity_admin_service.dart';

class AssignationResponsablesPage extends StatefulWidget {
  const AssignationResponsablesPage({super.key});

  @override
  State<AssignationResponsablesPage> createState() =>
      _AssignationResponsablesPageState();
}

class _AssignationResponsablesPageState
    extends State<AssignationResponsablesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignation des Responsables'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DistrictModel>('districts').listenable(),
        builder: (context, Box<DistrictModel> box, _) {
          final districts = box.values.toList();

          if (districts.isEmpty) {
            return const Center(child: Text('Aucun district trouvé.'));
          }

          return ListView.builder(
            itemCount: districts.length,
            itemBuilder: (context, index) {
              final district = districts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(district.name),
                  subtitle: Text(
                      'Resp: ${district.responsibleName.isEmpty ? "Non assigné" : district.responsibleName}'),
                  children: [
                    _buildUserDropdown(context, district, 'Responsable', (val) {
                      if (val != null) {
                        _handleAssign(district, val, true);
                      }
                    }),
                    _buildUserDropdown(context, district, 'Suppléant', (val) {
                      if (val != null) {
                        _handleAssign(district, val, false);
                      }
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleAssign(
      DistrictModel district, String userId, bool isPrincipal) async {
    try {
      final user = Hive.box<User>('users').get(userId);
      if (user == null) return;

      await EntityAdminService.assignLeadership(
        entityId: district.id,
        entityName: district.name,
        entityType: 'DISTRICT',
        principal: isPrincipal ? user : null,
        deputy: isPrincipal ? null : user,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignation réussie')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Widget _buildUserDropdown(BuildContext context, DistrictModel district,
      String label, Function(String?) onChanged) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<User>('users').listenable(),
      builder: (context, Box<User> userBox, _) {
        final users = userBox.values.toList();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: label, border: const OutlineInputBorder()),
            items: users
                .map((user) => DropdownMenuItem(
                      value: user.id,
                      child: Text(user.fullName),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

