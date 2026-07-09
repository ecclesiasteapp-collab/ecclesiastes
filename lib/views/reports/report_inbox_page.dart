import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/church_report.dart';
import '../../models/hierarchy_models.dart';
import '../../services/auth_service.dart';
import '../../services/entite_scope_service.dart';
import '../../services/repository_providers.dart';

class ReportInboxPage extends ConsumerStatefulWidget {
  const ReportInboxPage({super.key});

  @override
  ConsumerState<ReportInboxPage> createState() => _ReportInboxPageState();
}

class _ReportInboxPageState extends ConsumerState<ReportInboxPage> {
  List<ChurchReport> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final repo = ref.read(reportRepositoryProvider);
    final allReports = await repo.getReportsByStatus(ReportStatus.soumis);
    
    final scope = EntiteScopeService.getActiveScope();
    final String? activeId = scope['id'];
    final activeLevel = scope['level'];

    setState(() {
      _reports = allReports.where((report) {
        if (activeLevel == EntityLevel.communaute) {
          return report.nomEntite == activeId;
        } else if (activeLevel == EntityLevel.district) {
          return report.nomDistrict == activeId;
        } else if (activeLevel == EntityLevel.champ) {
          return report.nomChamp == activeId;
        }
        return true;
      }).toList()
        ..sort((a, b) => b.dateRapport.compareTo(a.dateRapport));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        title: const Text('Boîte de Réception', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${_reports.length} rapports en attente de validation',
                    style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _reports.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _reports.length,
                          itemBuilder: (context, index) => _buildReportCard(_reports[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildReportCard(ChurchReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF003366).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.description, color: Color(0xFF003366)),
        ),
        title: Text(
          report.type.name.toUpperCase(),
          style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'De: ${report.nomEntite}',
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
            Text(
              'Le ${DateFormat('dd/MM/yyyy').format(report.dateRapport)}',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF003366)),
        onTap: () => context.push('/reports/detail/${report.id}'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Aucun rapport en attente',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), foregroundColor: Colors.white),
            child: const Text('Retour'),
          )
        ],
      ),
    );
  }
}
