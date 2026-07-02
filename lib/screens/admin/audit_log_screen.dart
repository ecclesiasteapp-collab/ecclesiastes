// lib/screens/admin/audit_log_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/audit_log.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal des activités (Audit)'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AuditLog>('audit_logs').listenable(),
        builder: (context, Box<AuditLog> box, _) {
          final logs = box.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

          if (logs.isEmpty) {
            return const Center(child: Text('Aucune activité enregistrée.'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: Icon(
                  _getIconForAction(log.actionType),
                  color: _isCritical(log.actionType) ? Colors.red : Colors.blue,
                ),
                title: Text(log.actionType),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Utilisateur: ${log.adminId}'),
                    Text('Cible: ${log.targetType} (${log.targetId})'),
                    Text('Modifs: ${log.changesJson}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(log.timestamp.toString().substring(0, 16), style: const TextStyle(fontSize: 10)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForAction(String action) {
    final a = action.toLowerCase();
    if (a.contains('assign') || a.contains('add')) return Icons.person_add;
    if (a.contains('delete') || a.contains('remove')) return Icons.delete_forever;
    if (a.contains('warning') || a.contains('critical')) return Icons.warning;
    return Icons.info_outline;
  }

  bool _isCritical(String action) {
    final a = action.toLowerCase();
    return a.contains('delete') || a.contains('critical') || a.contains('error');
  }
}

