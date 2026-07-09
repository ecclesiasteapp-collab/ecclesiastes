import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../providers/scope_provider.dart';
import '../../domain/services/hub_service.dart';
import '../../widgets/dashboard/entite_hierarchy_pills.dart';
import 'library_page.dart';
import 'finance_dashboard.dart';
import 'record_offering_form.dart';
import 'family_list_page.dart';
import 'arimathee_page.dart';
import 'inventory_page.dart';
import 'construction_page.dart';
import 'hub_charts_widget.dart';

class ERPHubPage extends ConsumerWidget {
  const ERPHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mandates = ref.watch(activeMandatesProvider);
    final statsAsync = ref.watch(erpStatisticsProvider);
    final hubService = ref.watch(hubServiceProvider);
    final menus = hubService.getAvailableMenus(mandates);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hub Ecclésiaste"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Exporter le rapport consolidé",
            onPressed: () => _exportReport(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EntiteHierarchyPills(),
            const SizedBox(height: 20),
            Text(
              "Bienvenue,",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text("Point d'accès aux services de l'Église"),
            const SizedBox(height: 24),
            
            // --- SECTION PERFORMANCE ---
            statsAsync.when(
              data: (stats) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: "Membres", value: "${stats.totalMembers}"),
                    _StatItem(label: "Ministres", value: "${stats.totalMinisters}"),
                    _StatItem(label: "Rapports", value: "${stats.pendingReports}", isAlert: stats.pendingReports > 0),
                  ],
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 24),
            const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return _HubMenuCard(menu: menu);
              },
            ),

            const SizedBox(height: 32),
            const ERPHubChartsWidget(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    final statsAsync = ref.read(erpStatisticsProvider);
    if (statsAsync.hasValue) {
      final exportUseCase = ref.read(exportConsolidatedReportPdfProvider);
      await exportUseCase.execute(
        title: "Rapport Mensuel Consolidé",
        entityName: "Communauté de Kinshasa",
        stats: statsAsync.value!,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les statistiques ne sont pas encore prêtes."))
      );
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;
  const _StatItem({required this.label, required this.value, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: isAlert ? Colors.red : Theme.of(context).primaryColor
        )),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }
}

class _HubMenuCard extends StatelessWidget {
  final HubMenuItem menu;
  const _HubMenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigation logic
          if (menu.route == "/library") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ERPLibraryPage()),
            );
          } else if (menu.route == "/erp/finance") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ERPFinanceDashboard()),
            );
          } else if (menu.route == "/erp/families") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ERPFamilyListPage()),
            );
          } else if (menu.route == "/erp/arimathee") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ArimatheePage()),
            );
          } else if (menu.route == "/erp/inventory") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryPage()),
            );
          } else if (menu.route == "/erp/construction") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConstructionPage()),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIcon(menu.icon), size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              menu.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'book': return Icons.book;
      case 'assignment': return Icons.assignment;
      case 'people': return Icons.people;
      case 'payments': return Icons.payments;
      case 'house': return Icons.house;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'inventory': return Icons.inventory;
      case 'construction': return Icons.construction;
      default: return Icons.help;
    }
  }
}
