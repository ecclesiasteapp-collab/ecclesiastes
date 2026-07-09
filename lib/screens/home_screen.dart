import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecclesiaste'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bienvenue dans l\'application Ecclesiaste',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildMenuButton(
                context,
                icon: Icons.person_add,
                label: 'Inscription Membre',
                route: '/member/register',
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                icon: Icons.people,
                label: 'Répertoire des Membres',
                route: '/members',
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                icon: Icons.assignment,
                label: 'Rapport Service Divin',
                route: '/report/service-divin',
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                icon: Icons.history,
                label: 'Historique des Rapports',
                route: '/reports/history',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required String route}) {
    return ElevatedButton.icon(
      onPressed: () => context.push(route),
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
