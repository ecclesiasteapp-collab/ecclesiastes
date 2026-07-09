import '../entities/mandate.dart';

class HubMenuItem {
  final String label;
  final String route;
  final String icon;

  HubMenuItem({required this.label, required this.route, required this.icon});
}

class HubService {
  List<HubMenuItem> getAvailableMenus(List<Mandate> activeMandates) {
    final List<HubMenuItem> menus = [
      HubMenuItem(label: 'Bibliothèque', route: '/library', icon: 'book'),
    ];

    for (final mandate in activeMandates) {
      if (mandate.type == MandateType.ordination || mandate.type == MandateType.nomination) {
        // Accès aux rapports et à la gestion des membres
        if (!menus.any((m) => m.route == '/reports')) {
          menus.add(HubMenuItem(label: 'Rapports', route: '/reports', icon: 'assignment'));
          menus.add(HubMenuItem(label: 'Membres', route: '/members', icon: 'people'));
        }
        
        // Accès aux finances pour les ministres et responsables
        if (!menus.any((m) => m.route == '/erp/finance')) {
          menus.add(HubMenuItem(label: 'Finances', route: '/erp/finance', icon: 'payments'));
        }

        // Accès à la gestion des familles
        if (!menus.any((m) => m.route == '/erp/families')) {
          menus.add(HubMenuItem(label: 'Familles', route: '/erp/families', icon: 'house'));
        }

        // Accès au module Arimathée (Social)
        if (!menus.any((m) => m.route == '/erp/arimathee')) {
          menus.add(HubMenuItem(label: 'Arimathée', route: '/erp/arimathee', icon: 'volunteer_activism'));
        }

        // Accès à l'inventaire
        if (!menus.any((m) => m.route == '/erp/inventory')) {
          menus.add(HubMenuItem(label: 'Inventaire', route: '/erp/inventory', icon: 'inventory'));
        }

        // Accès aux projets de construction
        if (!menus.any((m) => m.route == '/erp/construction')) {
          menus.add(HubMenuItem(label: 'Constructions', route: '/erp/construction', icon: 'construction'));
        }
      }
    }

    return menus;
  }
}
