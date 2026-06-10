import 'package:flutter/material.dart';
import '../core/models/validation_task.dart';
import '../core/services/validation_service.dart';

class ValidationQueueWidget extends StatelessWidget {
  final List<ValidationTask> tasks;
  const ValidationQueueWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Aucune tâche en attente'),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: ListTile(
          leading: Icon(
            Icons.check_circle, 
            color: tasks[i].status == ValidationStatus.submitted ? Colors.orange : Colors.green
          ),
          title: Text(tasks[i].entityType),
          subtitle: Text('Soumis le ${tasks[i].createdAt.day}/${tasks[i].createdAt.month}'),
          trailing: tasks[i].status == ValidationStatus.submitted
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green), 
                    onPressed: () => _approve(context, tasks[i].id, 'COMMUNITY')
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red), 
                    onPressed: () => _reject(context, tasks[i].id)
                  ),
                ])
              : const Icon(Icons.lock, color: Colors.grey),
        ),
      ),
    );
  }

  void _approve(BuildContext ctx, int id, String level) async {
    final success = await ValidationService.approveTask(id, 'CURRENT_USER_ID', level);
    if (success && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('✅ Validé'), backgroundColor: Colors.green)
      );
    }
  }

  void _reject(BuildContext ctx, int id) {
     ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('❌ Rejeté'), backgroundColor: Colors.red)
      );
  }
}
