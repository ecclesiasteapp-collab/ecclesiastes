import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/entite_scope_service.dart';
import 'package:ecclesiastes/utils/constants.dart';
import 'package:ecclesiastes/views/dashboard_page.dart';
import 'package:ecclesiastes/views/forgot_password_page.dart';
import 'package:ecclesiastes/views/register_page.dart';
import 'package:ecclesiastes/widgets/ena_logo.dart';
import 'package:ecclesiastes/widgets/searchable_dropdown.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifiantController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  String? _selectedNiveau;
  String? _selectedMinistere;
  String? _selectedRole;
  
  // Liste déroulante pour Niveau (Entités)
  final List<String> _niveaux = [
    'Église internationale',
    'Église territoriale',
    'Champ apostolique',
    'District',
    'Communauté',
    'Commissions',
  ];
  
  // Rôles dynamiques selon le niveau sélectionné
  final Map<String, List<String>> _rolesParNiveau = {
    'Église internationale': [
      'Apôtre-Patriarche',
      'Secrétaire international',
    ],
    'Église territoriale': [
      'Apôtre de district',
      'Apôtre de district adjoint',
      'Super Administrateur',
    ],
    'Champ apostolique': [
      'Apôtre du champ apostolique',
      'Apôtre du champ apostolique adjoint',
      'Secrétaire de champ',
    ],
    'District': [
      'Responsable de district (ministère sacerdotal)',
      'Suppléant responsable de district (ministère sacerdotal)',
      'Secrétaire de district',
    ],
    'Communauté': [
      'Aucune fonction dirigeante',
      'Responsable de communauté (ministère sacerdotal)',
      'Suppléant responsable de communauté (ministère sacerdotal)',
      'Secrétaire de communauté',
      'Trésorier de communauté',
    ],
    'Commissions': AppConstants.commissions,
  };
  
  List<String> _rolesDisponibles = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final identifiant = _identifiantController.text.trim();
      final isSuperAdminEmail = identifiant.toLowerCase() == 'superadmin@ecclesiastes.rdc';

      if (!isSuperAdminEmail && (_selectedNiveau == null || _selectedMinistere == null)) {
        _snack('Veuillez sélectionner votre niveau et ministère.');
        return;
      }

      setState(() => _isLoading = true);
      try {
        final success = await AuthService.login(
          identifiant: identifiant,
          password: _passwordController.text,
          communauteId: 'AUTO', 
          ministere: _selectedMinistere,
          roleLabel: _selectedRole ?? 'Membre',
        );

        if (!mounted) return;
        if (success) {
          if (AuthService.currentUser != null) {
            final cid = AuthService.currentUser!['communaute_id'];
            if (AuthService.isSuperAdmin() && (cid == null || cid == 'ROOT' || cid == 'AUTO')) {
              await EntiteScopeService.initDefaultForAdmin();
            } else {
              await EntiteScopeService.initFromCommunaute(cid ?? 'COMM_01');
            }
          }
          if (!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
        } else {
          _snack('Identifiant ou mot de passe incorrect.');
        }
      } catch (e) {
        _snack('Erreur de connexion : ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E6BA8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo ENA
                const EnaLogo(size: 100),
                
                const SizedBox(height: 24),
                const Text('Bienvenue !', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text('Connectez-vous à votre communauté', style: TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 32),
                
                // Champ Identifiant
                SizedBox(
                  width: 320,
                  child: TextFormField(
                    controller: _identifiantController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline, color: primaryColor),
                      labelText: 'Identifiant ou Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Champ Mot de passe
                SizedBox(
                  width: 320,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: primaryColor),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Dropdowns Niveau et Ministère (Empilés pour éviter les débordements)
                SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      SearchableDropdown<String>(
                        items: _niveaux,
                        label: 'Niveau',
                        initialValue: _selectedNiveau,
                        displayStringForOption: (v) => v,
                        onSelected: (newValue) {
                          setState(() {
                            _selectedNiveau = newValue;
                            _selectedRole = null;
                            _rolesDisponibles = _rolesParNiveau[newValue] ?? [];
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SearchableDropdown<String>(
                        items: AppConstants.ministeres,
                        label: 'Ministère',
                        initialValue: _selectedMinistere,
                        displayStringForOption: (v) => v,
                        onSelected: (v) => setState(() => _selectedMinistere = v),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Dropdown Role / Fonction (Pleine largeur)
                SizedBox(
                  width: 320,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    isExpanded: true, // ✅ OBLIGATOIRE pour éviter l'overflow
                    decoration: InputDecoration(
                      labelText: 'Fonction / Rôle (optionnel)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _rolesDisponibles.map((v) => DropdownMenuItem(
                      value: v, 
                      child: Text(
                        v, 
                        style: const TextStyle(fontSize: 14), 
                        overflow: TextOverflow.ellipsis, // ✅ Coupe le texte si trop long
                      ),
                    )).toList(),
                    onChanged: _selectedNiveau == null ? null : (v) => setState(() => _selectedRole = v),
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 20.0),
                  child: Text(
                    'Le ministère correspond à votre ordination.\nLa fonction est optionnelle pour les membres sans mandat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
                
                // Bouton Se connecter
                SizedBox(
                  width: 320,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Se connecter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Liens footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                      child: const Text('Mot de passe oublié ?', style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline)),
                    ),
                    const Text(' | '),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                      child: const Text('Créer un compte', style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                const Text(
                  'Plateforme Ecclesiastes\nÉglise Néo-Apostolique RDC Ouest',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
