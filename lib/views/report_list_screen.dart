import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/church_report.dart';
import '../widgets/signature_pad_dialog.dart';
import '../services/auth_service.dart';
import '../services/report_pdf_generator.dart';
import '../services/repository_providers.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../services/access_control_service.dart';
import '../models/hierarchy_models.dart';
import '../models/user.dart';
import '../config/report_registry.dart';

class ReportListScreen extends ConsumerStatefulWidget {
  const ReportListScreen({super.key});

  @override
  ConsumerState<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends ConsumerState<ReportListScreen> {
  List<ChurchReport> _reports = [];
  bool _isLoading = true;
  ReportTypeExt? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final repo = ref.read(reportRepositoryProvider);
    final user = AuthService.currentUser;

    // Récupération via le repository
    final allReports = await repo.getAllChurchReports();
    final filteredByHierarchy = AccessControlService.filterByHierarchy<ChurchReport>(
      allReports,
      (r) => r.nomEntite, // En prod, utilisez entityId
      (r) => r.niveauEntite
    );

    // Filtrage par attribution
    final filteredReports = filteredByHierarchy.where((r) {
      if (user == null) return false;
      if (AuthService.isSuperAdmin() || user.role == UserRole.apotrePatriarche) return true;

      final bool isCommissionUser = user.commissionType != CommissionType.none && user.role == UserRole.membre;

      if (isCommissionUser) {
        // Un utilisateur de commission ne voit que les rapports de sa propre commission
        return r.type.name.toLowerCase().contains(user.commissionType!.name.toLowerCase());
      } else {
        // Un responsable d'entité voit les rapports d'entité et les rapports de commissions de son périmètre
        return true; 
      }
    }).toList();

    setState(() {
      _reports = filteredReports
        ..sort((a, b) => b.dateRapport.compareTo(a.dateRapport));
      _isLoading = false;
    });
  }


  List<ChurchReport> get _filteredReports {
    if (_selectedType == null) return _reports;
    return _reports.where((r) => r.type == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Rapports Officiels'),
        foregroundColor: Colors.white,
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )
          : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateReportSelector(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredReports.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) => _buildReportCard(_filteredReports[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReportSelector(context),
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateReportSelector(BuildContext context) {
    final user = AuthService.currentUser;
    final isCommissionUser = user?.commissionType != CommissionType.none && user?.role == UserRole.membre;
    
    // Filtrage des rapports selon le rôle
    final availableReports = ReportRegistry.all.values.where((config) {
      if (isCommissionUser) {
        // Un utilisateur de commission (non responsable d'entité) ne voit que les rapports mensuels de commission
        return config.id.endsWith('_mensuel');
      } else {
        // Un responsable d'entité/ministre voit les rapports d'entité (Sacristie, SD) et la Liste de Présence
        return ['sacristie', 'service_divin', 'presence_reunion', 'communique'].contains(config.id);
      }
    }).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choisir un type de rapport', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...availableReports.map((config) => ListTile(
              leading: Icon(config.icon, color: const Color(0xFF1B6B9E)),
              title: Text(config.title),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/reports/universal/${config.id}');
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text('Tous'),
            selected: _selectedType == null,
            onSelected: (_) => setState(() => _selectedType = null),
          ),
          const SizedBox(width: 8),
          ...ReportTypeExt.values.map((type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type.name.toUpperCase()),
              selected: _selectedType == type,
              onSelected: (_) => setState(() => _selectedType = type),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildReportCard(ChurchReport report) {
    final bool isSoumis = report.statut == ReportStatus.soumis;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _viewDetails(report),
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getStatusColor(report.statut).withValues(alpha: 0.1),
            child: Icon(_getIconForType(report.type), color: _getStatusColor(report.statut)),
          ),
          title: Text(
            '${report.type.name.toUpperCase()} - ${report.nomEntite}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            'Célébré le ${DateFormat('dd/MM/yyyy').format(report.dateRapport)}\nStatut: ${report.statut.name}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, report),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('Ouvrir Détails')),
              if (isSoumis && AuthService.isResponsable())
                const PopupMenuItem(value: 'validate', child: Text('✍️ Valider & Signer', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
              const PopupMenuItem(value: 'pdf', child: Text('Générer PDF')),
              const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.valide: return Colors.green;
      case ReportStatus.rejete: return Colors.red;
      case ReportStatus.soumis: return Colors.orange;
      default: return Colors.blueGrey;
    }
  }

  IconData _getIconForType(ReportTypeExt type) {
    if (type == ReportTypeExt.serviceDivin) return Icons.church;
    if (type == ReportTypeExt.reunionCommission || type.name.toLowerCase().contains('commission') || type.name.toLowerCase().contains('reunion')) {
      return Icons.groups;
    }
    return Icons.description;
  }

  void _handleMenuAction(String action, ChurchReport report) {
    if (action == 'validate') _signAndValidateReport(report);
    if (action == 'delete') _deleteReport(report);
    if (action == 'view') _viewDetails(report);
    if (action == 'pdf') _generatePDF(report);
  }

  Future<void> _generatePDF(ChurchReport report) async {
    try {
      final ByteData logoData = await rootBundle.load('assets/branding/logo_ena.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final pdfBytes = await ReportPdfGenerator.generate(report, logoBytes);
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur PDF: $e')));
      }
    }
  }

  void _viewDetails(ChurchReport report) {
    context.go('/reports/detail/${report.id}');
  }
  Future<void> _signAndValidateReport(ChurchReport report) async {
    final String? signature = await showDialog<String>(
      context: context,
      builder: (context) => const SignaturePadDialog(title: 'Validation Officielle'),
    );

    if (signature != null) {
      final repo = ref.read(reportRepositoryProvider);
      
      report.statut = ReportStatus.valide;
      report.signatureBase64 = signature;
      report.dateValidation = DateTime.now();
      report.validateur = AuthService.currentUser?.fullName;
      report.markAsUpdated(AuthService.currentUserId);
      
      await repo.saveChurchReport(report);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rapport validé avec signature numérique.')));
        _loadReports();
      }
    }
  }

  Future<void> _deleteReport(ChurchReport report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce rapport ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Supprimer', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(reportRepositoryProvider).deleteReport(report.id);
      _loadReports();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Aucun rapport enregistré', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

