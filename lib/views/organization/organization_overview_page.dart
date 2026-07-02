import 'package:flutter/material.dart';
import 'package:ecclesiastes/config/organization_config.dart';
import 'package:ecclesiastes/config/ministry_config.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';

class OrganizationOverviewPage extends StatelessWidget {
  const OrganizationOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation Ecclésiale'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('NIVEAUX D’ENTITÉS'),
            ...OrganizationConfig.entities.map((entity) => _buildEntityCard(entity)),

            const SizedBox(height: 32),
            _buildSectionTitle('COMMISSIONS OFFICIELLES'),
            ...OrganizationConfig.commissions
                .where((definition) => definition.type != CommissionType.none)
                .map((commission) => _buildCommissionCard(commission)),

            const SizedBox(height: 32),
            _buildSectionTitle('RANGS MINISTÉRIELS'),
            ...MinistryConfig.ranks.map((rank) => _buildMinistryCard(context, rank)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildEntityCard(EntityDefinition entity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blueGrey[50], child: Text(entity.code, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        title: Text(entity.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(entity.description),
      ),
    );
  }

  Widget _buildCommissionCard(CommissionDefinition commission) {
    final subtitle = commission.sousCommissions.isEmpty
        ? commission.description
        : '${commission.description}\nSous-commissions : ${commission.sousCommissions.join(', ')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.orange[50], child: const Icon(Icons.group_work, color: Colors.orange, size: 20)),
        title: Text(commission.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        isThreeLine: commission.sousCommissions.isNotEmpty,
      ),
    );
  }

  Widget _buildMinistryCard(BuildContext context, MinistryDefinition rank) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFF003366), child: const Icon(Icons.person, color: Colors.white, size: 20)),
        title: Text(rank.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(rank.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.info_outline),
        onTap: () => _showMinistryDetails(context, rank),
      ),
    );
  }

  void _showMinistryDetails(BuildContext context, MinistryDefinition rank) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text(rank.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const SizedBox(height: 12),
            Text(rank.description, style: const TextStyle(fontSize: 16, height: 1.5)),
            const Divider(height: 40),
            const Text('TÂCHES ET RESPONSABILITÉS :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
            const SizedBox(height: 12),
            ...rank.tasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(child: Text(task, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

