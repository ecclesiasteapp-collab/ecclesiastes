import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
// Assurez-vous d'avoir un écran de création/modification de rapport
// import 'create_report_screen.dart'; 

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  late Future<List<Map<String, dynamic>>> _myReportsFuture;

  @override
  void initState() {
    super.initState();
    _loadMyReports();
  }

  void _loadMyReports() {
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      _myReportsFuture = DatabaseHelper.instance.getReportsByAuthor(currentUser.id);
    } else {
      _myReportsFuture = Future.value([]);
    }
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'valide':
        return Icons.check_circle;
      case 'rejete':
        return Icons.cancel;
      case 'soumis':
        return Icons.hourglass_top;
      default: // brouillon
        return Icons.edit;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'valide':
        return Colors.green;
      case 'rejete':
        return Colors.red;
      case 'soumis':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Rapports Soumis')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _myReportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Vous n\'avez soumis aucun rapport.'));
          }

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final status = report['status']?.toString() ?? 'brouillon';
              final date = DateTime.tryParse(report['dateSoumission'] ?? report['createdAt'] ?? '');
              final formattedDate = date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Date inconnue';

              return ListTile(
                leading: Icon(_getIconForStatus(status), color: _getColorForStatus(status)),
                title: Text(report['type'] ?? 'Rapport'),
                subtitle: Text('Statut: ${status.toUpperCase()} - $formattedDate'),
                trailing: (status == 'rejete' || status == 'brouillon') ? const Icon(Icons.chevron_right) : null,
                onTap: (status == 'rejete' || status == 'brouillon')
                    ? () {
                        // Naviguer vers l'écran d'édition en passant les données du rapport
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => CreateReportScreen(existingReport: report))).then((_) => setState(_loadMyReports));
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
