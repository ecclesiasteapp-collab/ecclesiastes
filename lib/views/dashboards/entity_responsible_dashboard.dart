import 'package:flutter/material.dart';
import '../../models/hierarchy_models.dart';
import '../../services/pastoral_analytics_service.dart';
import '../../utils/constants.dart';

// ============================================
// MODÈLES DE DONNÉES LOCAUX (ADAPTÉS)
// ============================================

enum ReportStatus {
  pending,      // En attente de validation
  validated,    // Validé par le responsable
  transmitted,  // Transmis au niveau supérieur
  rejected      // Rejeté avec motif
}

enum NominationType {
  mandatement,  // §3.12 - Fonction dirigeante (à genoux, imposition des mains)
  nominationMinisterielle,  // §3.13.1 - Avec ministère (debout, poignée de main)
  nominationService,  // §3.13.2 - Sans ministère (moniteurs, responsables jeunesse)
  deliement  // §3.14 - Fin de mandat/nomination
}

class Responsable {
  final String id;
  final String nom;
  final String fonction;
  final String ministry;
  final DateTime dateMandatement;
  final String? photoUrl;

  Responsable({
    required this.id,
    required this.nom,
    required this.fonction,
    required this.ministry,
    required this.dateMandatement,
    this.photoUrl,
  });
}

class CommissionReport {
  final String id;
  final String commissionName;
  final String submittedBy;
  final DateTime submissionDate;
  final ReportStatus status;
  final Map<String, dynamic> data;

  CommissionReport({
    required this.id,
    required this.commissionName,
    required this.submittedBy,
    required this.submissionDate,
    required this.status,
    required this.data,
  });
}

class EventRequest {
  final String id;
  final String title;
  final String description;
  final DateTime proposedDate;
  final String requestedBy;
  final bool isApproved;
  final String? rejectionReason;

  EventRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.proposedDate,
    required this.requestedBy,
    this.isApproved = false,
    this.rejectionReason,
  });
}

class NominationRequest {
  final String id;
  final NominationType type;
  final String candidateName;
  final String position;
  final String justification;
  final DateTime proposedDate;
  final bool isApproved;

  NominationRequest({
    required this.id,
    required this.type,
    required this.candidateName,
    required this.position,
    required this.justification,
    required this.proposedDate,
    this.isApproved = false,
  });
}

// ============================================
// PAGE PRINCIPALE DU RESPONSABLE D'ENTITÉ
// ============================================

class EntityResponsibleDashboard extends StatefulWidget {
  final EntityLevel entityLevel;
  final String entityName;
  final Responsable responsable;
  final Responsable? suppleant;  // L'adjoint/suppléant
  final List<CommissionReport> pendingReports;
  final List<EventRequest> pendingEvents;
  final List<NominationRequest> pendingNominations;

  const EntityResponsibleDashboard({
    super.key,
    required this.entityLevel,
    required this.entityName,
    required this.responsable,
    this.suppleant,
    required this.pendingReports,
    required this.pendingEvents,
    required this.pendingNominations,
  });

  @override
  State<EntityResponsibleDashboard> createState() => _EntityResponsibleDashboardState();
}

class _EntityResponsibleDashboardState extends State<EntityResponsibleDashboard> 
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  late List<String> _tabs;

  @override
  void initState() {
    super.initState();
    
    // Les onglets s'adaptent selon le niveau
    _tabs = [
      'Spirituel',
      'Physique',
      'Commissions',
      'Rapports',
      'Événements',
      'Nominations',
    ];
    
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getEntityLevelTitle(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.entityName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSpiritualTab(),
          _buildOrganizationalTab(),
          _buildCommissionsTab(),
          _buildReportsTab(),
          _buildEventsTab(),
          _buildNominationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickActions(context),
        backgroundColor: const Color(0xFF003366),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Action', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSpiritualTab() {
    final stats = PastoralAnalyticsService.getSacramentalStatus(widget.entityName, widget.entityLevel);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDirectionHeader(),
          const SizedBox(height: 24),
          _buildSectionTitle('Alertes Pastorales', Icons.notification_important),
          Card(
            elevation: 2,
            child: Column(
              children: [
                if (stats['Jeunes (14+) baptisés non scellés']! > 0)
                  _buildPastoralAlert(
                    '${stats['Jeunes (14+) baptisés non scellés']} Jeunes (14+) baptisés non scellés',
                    'Candidats potentiels pour la Confirmation',
                    Colors.red,
                  ),
                if (stats['Besoins pastoraux (Incohérences)']! > 0)
                  _buildPastoralAlert(
                    '${stats['Besoins pastoraux (Incohérences)']} Incohérences sacramentelles',
                    'Vérifier le statut Sainte-Cène/Scellement',
                    Colors.orange,
                  ),
                if (stats['Baptisés non scellés']! > 0)
                  _buildPastoralAlert(
                    '${stats['Baptisés non scellés']} Membres baptisés en attente du Saint-Scellé',
                    'Préparation pastorale requise',
                    Colors.blue,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Devoirs Spirituels (§3.20)', Icons.church),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AppConstants.devoirsMinistres.take(3).map((d) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $d', style: const TextStyle(fontSize: 13)),
                  )
                ).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Statistiques Sacramentelles', Icons.water_drop),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSacramentRow('Membres nés NAC', '${stats['Membres nés NAC']}', Icons.family_restroom, Colors.green),
                  _buildSacramentRow('Membres convertis', '${stats['Convertis']}', Icons.person_add, Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Devoirs Organisationnels', Icons.business),
          Card(elevation: 2, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getOrganizationalDuties()))),
          const SizedBox(height: 24),
          _buildSectionTitle('Lieux de Culte', Icons.church),
          Card(elevation: 2, child: Column(children: _getPhysicalAspects())),
        ],
      ),
    );
  }

  Widget _buildCommissionsTab() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: AppConstants.commissionsDashboard.take(8).map((comm) {
        final int iconCode = comm['icon'] as int;
        // ignore: non_const_argument_for_const_parameter
        final iconData = IconData(iconCode, fontFamily: 'MaterialIcons');
        return _buildCommCard(comm['nom'], iconData, _getCommColor(comm['nom']));
      }).toList(),
    );
  }

  Color _getCommColor(String name) {
    if (name.contains('Ecodim')) return Colors.orange;
    if (name.contains('Jeunesse')) return Colors.green;
    if (name.contains('Musique')) return Colors.purple;
    if (name.contains('Econfi')) return Colors.teal;
    return Colors.blue;
  }

  Widget _buildCommCard(String name, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() => const Center(child: Text('Liste des Rapports'));
  Widget _buildEventsTab() => const Center(child: Text('Événements'));
  Widget _buildNominationsTab() => const Center(child: Text('Nominations'));

  // --- WIDGETS ---
  Widget _buildDirectionHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 35, child: Icon(Icons.person, size: 35)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.responsable.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.responsable.fonction),
              Text('Ministère: ${widget.responsable.ministry}', style: const TextStyle(fontSize: 12)),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(children: [Icon(icon, color: const Color(0xFF003366)), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]);
  }

  Widget _buildPastoralAlert(String title, String subtitle, Color color) {
    return ListTile(leading: Icon(Icons.warning_amber, color: color), title: Text(title), subtitle: Text(subtitle));
  }

  Widget _buildSacramentRow(String title, String val, IconData icon, Color color) {
    return ListTile(leading: Icon(icon, color: color), title: Text(title), trailing: Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: color)));
  }

  String _getEntityLevelTitle() {
    switch (widget.entityLevel) {
      case EntityLevel.communaute: return 'Communauté';
      case EntityLevel.district: return 'District';
      case EntityLevel.champ: return 'Champ Apostolique';
      case EntityLevel.regionApostolique: return 'Région Apostolique';
      case EntityLevel.territoriale: return 'Église Territoriale';
      case EntityLevel.internationale: return 'Église Internationale';
    }
  }

  List<Widget> _getOrganizationalDuties() => [const Text('• Administration'), const Text('• Finances')];
  List<Widget> _getPhysicalAspects() => [const ListTile(title: Text('État du lieu de culte'), trailing: Text('Conforme', style: TextStyle(color: Colors.green)))];

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(context: context, builder: (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        leading: const Icon(Icons.church), 
        title: const Text('Rapport Service Divin / Activité'), 
        onTap: () {
          Navigator.pop(ctx);
          Navigator.pushNamed(context, '/create-report');
        }
      ),
      ListTile(
        leading: const Icon(Icons.account_balance_wallet), 
        title: const Text('Rapport Cotisation & Collecte (Econfi)'), 
        onTap: () {
          Navigator.pop(ctx);
          Navigator.pushNamed(context, '/fundraising-report');
        }
      ),
      ListTile(
        leading: const Icon(Icons.person_add), 
        title: const Text('Proposer Nomination'), 
        onTap: () => Navigator.pop(ctx)
      ),
    ]));
  }
}

