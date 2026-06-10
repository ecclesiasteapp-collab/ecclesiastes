import 'package:ecclesiastes/models/fundraising_report.dart';
import 'package:ecclesiastes/services/fundraising_pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:printing/printing.dart';
import '../models/church_report.dart';
import '../services/report_pdf_generator.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  String _searchQuery = '';
  ReportTypeExt? _typeFilter;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mes Rapports Officiels'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
          child: Column(
            children: [
              _buildHeader(isWeb),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<ChurchReport>('church_reports').listenable(),
                  builder: (context, Box<ChurchReport> churchBox, _) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box<FundraisingReport>('fundraising_reports').listenable(),
                      builder: (context, Box<FundraisingReport> fundBox, _) {
                        // Combiner les rapports
                        final List<dynamic> allReports = [];
                        allReports.addAll(churchBox.values);
                        allReports.addAll(fundBox.values);

                        final filtered = allReports.where((r) {
                          String name = "";
                          String off = "";
                          bool matchType = false;

                          if (r is ChurchReport) {
                            name = r.nomEntite;
                            off = r.officiant;
                            matchType = _typeFilter == null || r.type == _typeFilter;
                          } else if (r is FundraisingReport) {
                            name = r.entityName;
                            off = r.rapporteur;
                            matchType = _typeFilter == null; // Pour l'instant on montre tout si c'est un rapport de fonds
                          } else {
                            return false;
                          }

                          final matchSearch = name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                              off.toLowerCase().contains(_searchQuery.toLowerCase());
                          return matchSearch && matchType;
                        }).toList();

                        filtered.sort((a, b) {
                          DateTime da = a is ChurchReport ? a.dateRapport : (a as FundraisingReport).dateCollecte;
                          DateTime db = b is ChurchReport ? b.dateRapport : (b as FundraisingReport).dateCollecte;
                          return db.compareTo(da);
                        });

                        if (filtered.isEmpty) {
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final r = filtered[index];
                            if (r is ChurchReport) return _buildReportCard(r);
                            return _buildFundraisingCard(r as FundraisingReport);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-report'),
        backgroundColor: const Color(0xFF003366),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nouveau Rapport', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(bool isWeb) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher par entité ou officiant...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(null, 'Tous'),
                ...ReportTypeExt.values.map((t) => _buildFilterChip(t, _getReportTypeLabel(t))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ReportTypeExt? type, String label) {
    final isSelected = _typeFilter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
        selected: isSelected,
        onSelected: (v) => setState(() => _typeFilter = v ? type : null),
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF003366),
      ),
    );
  }

  Widget _buildReportCard(ChurchReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(report.statut).withValues(alpha: 0.1),
          child: Icon(_getReportIcon(report.type), color: _getStatusColor(report.statut)),
        ),
        title: Text(
          _getReportTypeLabel(report.type),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${report.nomEntite} • ${report.officiant}'),
            Text(
              'Le ${report.dateRapport.day}/${report.dateRapport.month}/${report.dateRapport.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
              onPressed: () => _printReport(report),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          // Détails du rapport
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Aucun rapport trouvé', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }

  String _getReportTypeLabel(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return 'Service Divin';
      case ReportTypeExt.reunionFreres: return 'Réunion de Frères';
      case ReportTypeExt.serviceJeunesse: return 'Service de Jeunesse';
      case ReportTypeExt.serviceEcodim: return 'Service Ecodim';
      case ReportTypeExt.mariage: return 'Mariage';
      case ReportTypeExt.serviceFunebre: return 'Service Funèbre';
      case ReportTypeExt.concert: return 'Concert';
      case ReportTypeExt.evangelisation: return 'Évangélisation';
      default: return 'Autre';
    }
  }

  IconData _getReportIcon(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return Icons.church;
      case ReportTypeExt.serviceEcodim: return Icons.child_care;
      case ReportTypeExt.serviceJeunesse: return Icons.people;
      case ReportTypeExt.mariage: return Icons.favorite;
      case ReportTypeExt.evangelisation: return Icons.campaign;
      default: return Icons.description;
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.valide: return Colors.green;
      case ReportStatus.soumis: return Colors.blue;
      case ReportStatus.rejete: return Colors.red;
      case ReportStatus.brouillon: return Colors.orange;
      default: return Colors.grey;
    }
  }

  Widget _buildFundraisingCard(FundraisingReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withValues(alpha: 0.1),
          child: const Icon(Icons.account_balance_wallet, color: Colors.teal),
        ),
        title: Text(
          'Collecte: ${report.motif}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${report.entityName} • ${report.rapporteur}'),
            Text(
              'Total: ${report.totalFC} FC / ${report.totalDevise} USD • Le ${report.dateCollecte.day}/${report.dateCollecte.month}/${report.dateCollecte.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
              onPressed: () => _printFundraisingReport(report),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Future<void> _printFundraisingReport(FundraisingReport report) async {
    final pdfBytes = await FundraisingPdfGenerator.generate(report);
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  Future<void> _printReport(ChurchReport report) async {
    final pdfBytes = await ReportPdfGenerator.generate(report);
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }
}
