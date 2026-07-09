import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/theme/app_theme.dart';

class WelcomePageModern extends StatefulWidget {
  const WelcomePageModern({super.key});

  @override
  State<WelcomePageModern> createState() => _WelcomePageModernState();
}

class _WelcomePageModernState extends State<WelcomePageModern> {
  String? _selectedNiveau;
  String? _selectedMinistere;
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme, // Force le thème clair pour cette page
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo conforme au screenshot (Cercle bleu avec croix)
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0066CC),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logos/logo_accueil.png', // Chemin à vérifier
                        width: 140,
                        height: 140,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.church,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Bienvenue !',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005599),
                  ),
                ),
                const Text(
                  'connectez-vous à votre communauté',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // Champs Dropdown avec labels
                _buildLabeledDropdown('Niveau', ['District', 'Communauté'], _selectedNiveau, (v) => setState(() => _selectedNiveau = v)),
                const SizedBox(height: 20),
                _buildLabeledDropdown('Ministère', ['Apôtre', 'Évêque', 'Ancien', 'Évangéliste', 'Prêtre', 'Diacre'], _selectedMinistere, (v) => setState(() => _selectedMinistere = v)),
                const SizedBox(height: 20),
                _buildLabeledDropdown('Role', ['Conducteur', 'Secrétaire', 'Membre'], _selectedRole, (v) => setState(() => _selectedRole = v)),

                const SizedBox(height: 40),

                // Bouton Se connecter
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005599),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
              ),

              const SizedBox(height: 20),

              // Lien direct vers les commissions
              TextButton.icon(
                onPressed: () => context.push('/commissions'),
                icon: const Icon(Icons.assignment_ind, color: Color(0xFF005599)),
                label: const Text(
                  'Consulter les Commissions',
                  style: TextStyle(color: Color(0xFF005599), fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 40),

                // Liens du bas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        'Créer un nouveau compte',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledDropdown(String label, List<String> options, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: options.map((String opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
