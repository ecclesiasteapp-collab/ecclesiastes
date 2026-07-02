import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/auth_service.dart';

class ManageCommissionsPage extends StatefulWidget {
  const ManageCommissionsPage({super.key});

  @override
  State<ManageCommissionsPage> createState() => _ManageCommissionsPageState();
}

class _ManageCommissionsPageState extends State<ManageCommissionsPage> {
  List<Map<String, dynamic>> _commissionResps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommissions();
  }

  Future<void> _loadCommissions() async {
    setState(() => _isLoading = true);
    final user = AuthService.currentUser;
    if (user != null && user.entityId != null) {
      final resps = await DatabaseHelper.instance.getCommissionResponsables(
        entiteId: user.entityId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _commissionResps = resps;
        _isLoading = false;
      });
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _commissionResps = [];
      _isLoading = false;
    });
  }

  void _nominateCommissionLead(CommissionType type) async {
    final users = await DatabaseHelper.instance.getAllUtilisateurs();

    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        String? selectedUserId;
        CommissionRole selectedRole = CommissionRole.responsable;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('Nommer : ${type.name.toUpperCase()}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  items: users
                      .map<DropdownMenuItem<String>>(
                        (u) => DropdownMenuItem<String>(
                          value: u['identifiant']?.toString(),
                          child: Text(u['full_name']?.toString() ?? 'Inconnu'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedUserId = val),
                  decoration: const InputDecoration(
                    labelText: 'Sélectionner un membre',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CommissionRole>(
                  initialValue: selectedRole,
                  items: CommissionRole.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedRole = val);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Rôle dans la commission',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedUserId == null) {
                    return;
                  }

                  final navigator = Navigator.of(dialogContext);
                  final user = AuthService.currentUser;
                  await DatabaseHelper.instance.upsertCommissionResponsable({
                    'commission_type': type.name,
                    'commission_nom': type.name.toUpperCase(),
                    'user_id': selectedUserId,
                    'role': selectedRole.name,
                    'entite_id': user?.entityId,
                    'date_nomination': DateTime.now().toIso8601String(),
                  });
                  if (!mounted) {
                    return;
                  }
                  navigator.pop();
                  if (!mounted) {
                    return;
                  }
                  _loadCommissions();
                },
                child: const Text('Confirmer'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Commissions'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: CommissionType.values.length - 1,
              itemBuilder: (context, index) {
                final type = CommissionType.values[index];
                final resp = _commissionResps.firstWhere(
                  (r) => r['commission_type'] == type.name,
                  orElse: () => {},
                );

                return ListTile(
                  leading: const Icon(Icons.group_work, color: Colors.blueGrey),
                  title: Text(type.name.toUpperCase()),
                  subtitle: Text(
                    resp.isNotEmpty
                        ? 'Responsable : ${resp['user_id']} (${resp['role']})'
                        : 'Aucun responsable nommé',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _nominateCommissionLead(type),
                    child: Text(resp.isNotEmpty ? 'Changer' : 'Nommer'),
                  ),
                );
              },
            ),
    );
  }
}

