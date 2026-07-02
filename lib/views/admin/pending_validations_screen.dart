import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
import 'report_detail_page.dart';

class PendingValidationsScreen extends StatefulWidget {
  const PendingValidationsScreen({super.key});

  @override
  State<PendingValidationsScreen> createState() => _PendingValidationsScreenState();
}

class _PendingValidationsScreenState extends State<PendingValidationsScreen> {
  late Future<List<Map<String, dynamic>>> _pendingReportsFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    // On récupère l'ID de l'entité de l'utilisateur pour ne voir que les rapports qu'il supervise.
    final currentUser = AuthService.currentUser;
    _pendingReportsFuture = DatabaseHelper.instance.getReportsByStatus('soumis', supervisingEntityId: currentUser?.entityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports à Valider'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pendingReportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun rapport en attente de validation.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final date = DateTime.tryParse(report['dateSoumission'] ?? '');
              final formattedDate = date != null ? DateFormat('dd/MM/yyyy HH:mm').format(date) : 'Date inconnue';

              return ListTile(
                leading: const Icon(Icons.hourglass_top, color: Colors.orange),
                title: Text(report['type'] ?? 'Rapport inconnu'),
                subtitle: Text('Par: ${report['rapporteurNom']} - Entité: ${report['nomEntite']} \nSoumis le: $formattedDate'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailPage(report: report),
                    ),
                  );
                  // Si la page de détail a retourné 'true', cela signifie qu'une action a été prise.
                  // On rafraîchit donc la liste.
                  if (result == true) {
                    setState(() {
                      _loadReports();
                    });
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
