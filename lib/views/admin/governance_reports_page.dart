import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/governance_report_service.dart';
import 'package:intl/intl.dart';

class GovernanceReportsPage extends StatefulWidget {
  const GovernanceReportsPage({super.key});

  @override
  State<GovernanceReportsPage> createState() => _GovernanceReportsPageState();
}

class _GovernanceReportsPageState extends State<GovernanceReportsPage> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final reports = await GovernanceReportService.getReportsHistory();
    setState(() {
      _reports = reports;
      _isLoading = false;
    });
  }

  void _showReportDetail(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rapport du ${DateFormat('dd/MM/yyyy').format(DateTime.parse(report['date_generation']))}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(height: 32),
              
              const Text('Alertes Critiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 8),
              ...(report['alertes'] as List).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(a.toString())),
                  ],
                ),
              )),
              
              const SizedBox(height: 24),
              const Text('Statistiques de Gouvernance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildDataRow('Responsables Titulaires', report['donnees']['governance']['Titulaires'].toString()),
              _buildDataRow('Responsables en Intérim', report['donnees']['governance']['Intérims'].toString()),
              _buildDataRow('Postes Vacants', report['donnees']['governance']['Vacants'].toString(), isWarning: true),
              _buildDataRow('Délégations Actives', report['donnees']['delegations'].toString()),
              
              const SizedBox(height: 24),
              const Text('Sécurité et Système', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildDataRow('Comptes Actifs', report['donnees']['security']['Actifs'].toString()),
              _buildDataRow('Comptes Suspendus', report['donnees']['security']['Suspendus'].toString(), isWarning: true),
              _buildDataRow('Taille du Stockage', '${(report['donnees']['storage_mb'] as double).toStringAsFixed(2)} MB'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isWarning ? Colors.orange : Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archives des Rapports'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(child: Text('Aucun rapport généré pour le moment.'))
              : ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    final date = DateTime.parse(report['date_generation']);
                    final alertCount = (report['alertes'] as List).length;

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.assignment, color: Colors.white),
                      ),
                      title: Text('Rapport Hebdomadaire - ${DateFormat('dd MMM yyyy').format(date)}'),
                      subtitle: Text('$alertCount alerte(s) identifiée(s)'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showReportDetail(report),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await GovernanceReportService.generateWeeklyReport();
          _loadReports();
        },
        label: const Text('Générer maintenant'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}

