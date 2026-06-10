import 'package:flutter/material.dart';

class CustomDashboardHeader extends StatelessWidget {
  final String userName;
  final String userTitle;
  final String? avatarUrl;
  final VoidCallback onMenuTap;
  final VoidCallback onLogout;

  const CustomDashboardHeader({
    super.key,
    required this.userName,
    required this.userTitle,
    this.avatarUrl,
    required this.onMenuTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      height: isDesktop ? 80 : 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          // Bloc Profil (Gauche)
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isDesktop ? 24 : 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null ? const Icon(Icons.person, color: Color(0xFF003366)) : null,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                ],
              ],
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: ListTile(leading: Icon(Icons.person_outline), title: Text('Mon Profil'))),
              const PopupMenuItem(value: 'settings', child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Paramètres'))),
              const PopupMenuItem(value: 'help', child: ListTile(leading: Icon(Icons.help_outline), title: Text('Aide'))),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'logout', child: ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Déconnexion', style: TextStyle(color: Colors.red)))),
            ],
            onSelected: (val) {
              if (val == 'logout') onLogout();
            },
          ),
          
          const Spacer(),
          
          // Titre (Centre)
          Flexible(
            child: Text(
              userTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF003366),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const Spacer(),
          
          // Menu Hamburger (Droite)
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF003366)),
            onPressed: onMenuTap,
          ),
        ],
      ),
    );
  }
}
