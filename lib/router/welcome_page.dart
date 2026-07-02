import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366), // Bleu officiel
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32), // Padding généreux comme LoginPage
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo circulaire harmonisé
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF003366).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/branding/logo_accueil.png',
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, _, __) => const Icon(
                          Icons.church,
                          size: 70,
                          color: Color(0xFF003366),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ecclésiaste',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Église Internationale',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                  const Text(
                    'Gestion complète de l\'Église\nNéo-Apostolique',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Bouton Connexion (Style LoginPage)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'SE CONNECTER',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bouton Créer un compte
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => context.go('/register'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF003366),
                        side: const BorderSide(color: Color(0xFF003366), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CRÉER UN COMPTE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Liens bas de page
                  TextButton(
                    onPressed: () => context.go('/legal'),
                    child: Text(
                      'Mentions légales • Version 1.0.0',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

