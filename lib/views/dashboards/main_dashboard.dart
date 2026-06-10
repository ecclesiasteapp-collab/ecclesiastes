import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../widgets/dashboard/custom_header.dart';
import '../../widgets/dashboard/hierarchy_nav.dart';
import '../../widgets/dashboard/news_carousel.dart';
import '../../widgets/dashboard/commission_grid.dart';
import '../../models/news_model.dart';
import '../../models/hierarchy_models.dart';
import '../../models/library_document.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../commissions/commission_detail_screen.dart';
import '../event_dashboard_page.dart';
import '../calendrier_page.dart';
import '../library_screen.dart';
import '../hierarchie_page.dart';
import '../../models/isar/event.dart';
import 'package:ecclesiastes/screens/about_screen.dart';
import 'package:ecclesiastes/views/bible_page.dart';
import 'entity_responsible_dashboard.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _activeHierarchyIndex = 2; // Champ (KSO)

  final List<String> _hierarchyLevels = [
    'Église Internationale',
    'Église Territoriale',
    'Champ (KSO)',
    'District (Kalamu)',
    'Communauté (Badiading)',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final userName = user?['nom_complet'] ?? 'Utilisateur';
    final userTitle = user?['role_label'] ?? 'Apostolic Administrator';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            CustomDashboardHeader(
              userName: userName,
              userTitle: userTitle,
              onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
              onLogout: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  HierarchyNav(
                    levels: _hierarchyLevels,
                    activeIndex: _activeHierarchyIndex,
                    onLevelTap: (index) {
                      setState(() => _activeHierarchyIndex = index);
                      _navigateToEntityDetail(index);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('À la Une', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1a1a1a))),
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<News>('news').listenable(),
                    builder: (context, Box<News> box, _) {
                      return NewsCarousel(newsList: box.values.toList());
                    },
                  ),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  _buildTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: _buildDrawer(),
    );
  }

  void _navigateToEntityDetail(int index) {
    final isSuperAdmin = AuthService.isSuperAdmin();
    EntityLevel level;
    String name = _hierarchyLevels[index];
    
    // Si l'utilisateur n'est pas Super Admin, il ne peut pas naviguer vers des niveaux supérieurs au sien
    // Pour simplifier ici, on laisse le Super Admin tout voir, et les autres sont limités par leurs données.
    
    switch (index) {
      case 0: level = EntityLevel.internationale; break;
      case 1: level = EntityLevel.territoriale; break;
      case 2: level = EntityLevel.champ; break;
      case 3: level = EntityLevel.district; break;
      case 4: level = EntityLevel.communaute; break;
      default: return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EntityResponsibleDashboard(
          entityLevel: level,
          entityName: name,
          responsable: Responsable(
            id: '1',
            nom: isSuperAdmin ? 'Nestor Mbuyi Kankolongo' : 'Apôtre Emmanuel NGOLO',
            fonction: isSuperAdmin ? 'Super Administrateur' : 'Apôtre de District',
            ministry: isSuperAdmin ? 'Apostolat' : 'Sacerdotal',
            dateMandatement: DateTime(2022, 7, 10),
          ),
          pendingReports: [],
          pendingEvents: [],
          pendingNominations: [],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFF003366),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF003366),
        indicatorWeight: 3,
        onTap: (index) => setState(() {}),
        tabs: const [
          Tab(text: 'Tout'),
          Tab(text: 'Événements'),
          Tab(text: 'Calendrier'),
          Tab(text: 'Bibliothèque'),
          Tab(text: 'Programmes'),
          Tab(text: 'Ministres'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final isSuperAdmin = AuthService.isSuperAdmin();
    
    switch (_tabController.index) {
      case 0: return _buildCommissionGrid();
      case 1: return _buildEventsView();
      case 2: return const SizedBox(height: 500, child: CalendrierPage());
      case 3: return SizedBox(height: 600, child: LibraryScreen(
        userCategory: isSuperAdmin ? UserCategory.responsable : UserCategory.membre,
        userLevel: EntityLevel.champ,
        userCommission: CommissionType.none,
        isSuperAdmin: isSuperAdmin,
      ));
      case 4: return _buildProgrammesView();
      case 5: return const SizedBox(height: 600, child: HierarchiePage());
      default: return const SizedBox();
    }
  }

  Widget _buildCommissionGrid() {
    return Column(
      children: [
        CommissionGrid(
          commissions: _getCommissionsData(),
          onTap: (comm) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommissionDetailScreen(
                  commissionName: comm.title,
                  leaderName: 'Pr. Didier KUYINDAMA',
                  progress: comm.progress,
                  entityId: 'ROOT',
                ),
              ),
            );
          },
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildEventsView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Event>('events_box').listenable(),
      builder: (context, Box<Event> box, _) {
        final events = box.values.toList();
        return SizedBox(
          height: 600,
          child: EventDashboardPage(events: events),
        );
      },
    );
  }

  Widget _buildProgrammesView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Event>('events_box').listenable(),
      builder: (context, Box<Event> box, _) {
        final events = box.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true, // ✅ Correction Erreur 2
          physics: const NeverScrollableScrollPhysics(), // ✅ Délègue le scroll au parent
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e = events[index];
            return _buildProgramCard(e.title, e.description, _getCategoryColor(e.category ?? ''));
          },
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ECODIM': return Colors.green;
      case 'JEUNESSE': return Colors.orange;
      case 'APOTRE': return Colors.red;
      default: return Colors.blue;
    }
  }

  Widget _buildProgramCard(String title, String subtitle, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.event_note, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () {},
      ),
    );
  }

  List<CommissionCardData> _getCommissionsData() {
    return AppConstants.commissionsDashboard.map((c) {
      String name = c['nom'];
      String sectionLabel = c['section'] == 'local' ? 'Administration & Support' : 'Technique & Soutien';
      double progress = 0.0;
      String status = 'Pas de responsable';
      if (name == 'Ecodim') { progress = 0.65; status = 'À jour'; }
      else if (name == 'Econfi') { progress = 0.82; status = 'À jour'; }
      else if (name == 'Jeunesse') { progress = 0.92; status = 'À jour'; }
      else if (name == 'Mamans') { status = 'En attente'; }
      return CommissionCardData(title: name, section: sectionLabel, progress: progress, status: status);
    }).toList();
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('KSO: 22 Districts / 186 Communautés', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          TextButton.icon(
            onPressed: () {},
            icon: const Text('Alertes Vacances', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
            label: const Icon(Icons.arrow_forward, size: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final user = AuthService.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF003366)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF003366))),
                const SizedBox(height: 10),
                Text(user?['nom_complet'] ?? 'Nestor Mbuyi', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user?['role_label'] ?? 'Super Administrateur', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.person_outline), title: const Text('Mon Profil'), onTap: () => Navigator.pushNamed(context, '/profile')),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Color(0xFF003366)),
            title: const Text('Bible TOB'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BiblePage()));
            },
          ),
          ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Paramètres'), onTap: () => Navigator.pushNamed(context, '/settings')),
          ListTile(leading: const Icon(Icons.help_outline), title: const Text('Aide'), onTap: () => Navigator.pushNamed(context, '/help')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF003366)),
            title: const Text('À Propos & Contact'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), 
            title: const Text('Déconnexion', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            }
          ),
        ],
      ),
    );
  }
}
