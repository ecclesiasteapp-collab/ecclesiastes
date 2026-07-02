import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/church_report.dart';
import '../../models/hierarchy_models.dart';
import '../../services/auth_service.dart';
import '../../services/entite_scope_service.dart';
import '../../core/theme.dart';

class ReportInboxPage extends StatefulWidget {
  const ReportInboxPage({super.key});

  @override
  State<ReportInboxPage> createState() => _ReportInboxPageState();
}

class _ReportInboxPageState extends State<ReportInboxPage> {
  late Box<ChurchReport> _reportBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _reportBox = Hive.box<ChurchReport>('church_reports');
    setState(() => _isLoading = false);
  }

  List<ChurchReport> _getIncomingReports() {
    final user = AuthService.currentUser;
    if (user == null) return [];

    final scope = EntiteScopeService.getActiveScope();
    final String? activeId = scope['id'];
    final activeLevel = scope['level'];

    return _reportBox.values.where((report) {
      // 1. Uniquement les rapports soumis (en attente de validation)
      if (report.statut != ReportStatus.soumis) return false;

      // 2. Filtrage par supervision hiérarchique
      // Un responsable voit les rapports de son entité ou de ses sous-entités
      if (activeLevel == EntityLevel.communaute) {
        return report.nomEntite == activeId;
      } else if (activeLevel == EntityLevel.district) {
        return report.nomDistrict == activeId;
      } else if (activeLevel == EntityLevel.champ) {
        return report.nomChamp == activeId;
      }
      
      return true; // Niveau international voit tout
    }).toList()
      ..sort((a, b) => b.dateRapport.compareTo(a.dateRapport));
  }

  @override
  Widget build(BuildContext context) {
    final reports = _getIncomingReports();

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Boîte de Réception', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${reports.length} rapports en attente de validation',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: reports.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: reports.length,
                          itemBuilder: (context, index) => _buildReportCard(reports[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildReportCard(ChurchReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.description, color: AppTheme.accent),
        ),
        title: Text(
          report.type.name.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'De: ${report.nomEntite}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              'Le ${DateFormat('dd/MM/yyyy').format(report.dateRapport)}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () => context.push('/reports/detail/${report.id}'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          const Text(
            'Aucun rapport en attente',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

