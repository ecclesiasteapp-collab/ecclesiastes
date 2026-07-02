import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiastes/services/auth_service.dart';

/// Un menu latéral (Drawer) qui adapte ses options selon le rôle de l'utilisateur.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = AuthService.isSuperAdmin();
    final user = AuthService.currentUser;

    // Récupération des informations de session stockées dans AuthService
    final String userName = user?.fullName ?? 'Utilisateur';
    final String userRole = user?.role.name ?? 'Ministre';

    return Drawer(
      child: Column(
        children: [
          // En-tête du Drawer (Profil utilisateur)
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            accountName: Text(userName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            accountEmail: Text(userRole),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.person, color: Color(0xFF003366), size: 40),
            ),
          ),

          // Liste des options de navigation communes
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavTile(context, Icons.dashboard_outlined,
                    'Tableau de bord', '/dashboard'),
                _buildNavTile(
                    context, Icons.people_outline, 'Membres', '/members'),
                _buildNavTile(
                    context, Icons.campaign_outlined, 'Annonces', '/announcements'),
                _buildNavTile(context, Icons.assignment_outlined,
                    'Rapports', '/reports'),
                _buildNavTile(context, Icons.group_outlined,
                    'Commissions', '/commissions'),
                _buildNavTile(context, Icons.menu_book_outlined, 'Sainte Bible',
                    '/bible'),
                _buildNavTile(context, Icons.library_books_outlined,
                    'Bibliothèque', '/library'),
                _buildNavTile(context, Icons.event_note_outlined,
                    'Programmes', '/programmes'),
                _buildNavTile(context, Icons.calendar_month_outlined,
                    'Calendrier', '/calendar'),
                _buildNavTile(context, Icons.account_tree_outlined,
                    'Hiérarchie', '/hierarchie'),
                _buildNavTile(context, Icons.account_tree_sharp,
                    'Organigramme', '/organigramme'),
                _buildNavTile(context, Icons.business_outlined,
                    'Organisation', '/organization'),
                _buildNavTile(context, Icons.account_balance_wallet_outlined,
                    'Finances', '/finances/journal'),
                _buildNavTile(context, Icons.help_outline,
                    'Aide & Support', '/help'),



                // --- SECTION RÉSERVÉE AU SUPER ADMIN ---
                if (isAdmin) ...[
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Text('ADMINISTRATION',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                  _buildNavTile(
                    context,
                    Icons.admin_panel_settings_outlined,
                    'Panneau de contrôle',
                    '/admin/panel',
                    color: Colors.red.shade700,
                  ),
                ],
              ],
            ),
          ),

          const Divider(),
          _buildNavTile(
              context, Icons.settings_outlined, 'Paramètres', '/settings'),
          _buildNavTile(context, Icons.info_outline, 'À propos', '/about'),

          // Bouton de déconnexion sécurisé
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title:
                const Text('Déconnexion', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content:
                      const Text('Voulez-vous vraiment vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await AuthService.logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: const Text('Se déconnecter',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavTile(
      BuildContext context, IconData icon, String label, String route,
      {Color? color, int? badgeCount}) {
    // Déterminer si cette tuile est la route actuelle
    final String currentLocation = GoRouterState.of(context).matchedLocation;
    final bool isSelected = route == '/'
        ? currentLocation == '/'
        : currentLocation.startsWith(route);

    final Color? effectiveColor =
        isSelected ? Theme.of(context).primaryColor : color;

    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(label,
          style: TextStyle(
            color: effectiveColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          )),
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.08),
      trailing: (badgeCount != null && badgeCount > 0)
          ? Badge(
              label: Text(badgeCount > 9 ? '9+' : '$badgeCount'),
              backgroundColor: Colors.red,
            )
          : null,
      onTap: () {
        Navigator.pop(context); // Fermer le drawer avant la navigation
        context.go(route);
      },
    );
  }
}

