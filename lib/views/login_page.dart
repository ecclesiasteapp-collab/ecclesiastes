import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import 'package:ecclesiaste/theme/app_theme.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  EntityLevel _selectedNiveau = EntityLevel.communaute;
  UserRole _selectedMinistere = UserRole.membre;
  EntityResponsibleRole _selectedRole = EntityResponsibleRole.responsable;
  CommissionType _selectedCommission = CommissionType.none;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final success = await AuthService.login(
      identifiant: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // On injecte les choix du dropdown dans l'utilisateur courant pour la démo/simulation
      AuthService.currentUser?.entityLevel = _selectedNiveau;
      AuthService.currentUser?.role = _selectedMinistere;
      AuthService.currentUser?.entityRole = _selectedRole.name;
      AuthService.currentUser?.commissionType = _selectedCommission;
      
      if (_selectedCommission != CommissionType.none) {
        AuthService.currentUser?.role = UserRole.respCommission;
        AuthService.currentUser?.commissionRole = _selectedRole == EntityResponsibleRole.responsable 
          ? CommissionRole.responsable 
          : CommissionRole.adjoint;
      }

      context.go('/dashboard');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou mot de passe incorrect'), backgroundColor: Colors.red),
      );
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF003366), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/logos/logo_accueil.png',
                      height: 100,
                      width: 100,
                      errorBuilder: (ctx, _, __) => const Icon(Icons.church, size: 80, color: Color(0xFF003366)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Bienvenue !', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  const Text('connectez-vous à votre communauté', style: TextStyle(color: Colors.black54, fontSize: 16)),
                  const SizedBox(height: 32),

                  // EMAIL
                  _buildLabel('Adresse Email ou Identifiant'),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('ex: nom@ena.org', Icons.alternate_email),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),

                  // MOT DE PASSE
                  _buildLabel('Mot de passe'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration('••••••••', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 24),

                  // NIVEAU
                  _buildLabel('Niveau'),
                  DropdownButtonFormField<EntityLevel>(
                    initialValue: _selectedNiveau,
                    decoration: _inputDecoration('', null),
                    items: EntityLevel.values.map((l) => DropdownMenuItem(value: l, child: Text(_getLevelLabel(l)))).toList(),
                    onChanged: (v) => setState(() => _selectedNiveau = v!),
                  ),
                  const SizedBox(height: 16),

                  // MINISTÈRE
                  _buildLabel('Ministère'),
                  DropdownButtonFormField<UserRole>(
                    initialValue: _selectedMinistere,
                    decoration: _inputDecoration('', null),
                    items: UserRole.values.take(15).map((r) => DropdownMenuItem(value: r, child: Text(_getRoleLabel(r)))).toList(),
                    onChanged: (v) => setState(() => _selectedMinistere = v!),
                  ),
                  const SizedBox(height: 16),

                  // COMMISSION
                  _buildLabel('Commission (si applicable)'),
                  DropdownButtonFormField<CommissionType>(
                    initialValue: _selectedCommission,
                    decoration: _inputDecoration('', null),
                    items: CommissionType.values.map((c) => DropdownMenuItem(value: c, child: Text(_getCommLabel(c)))).toList(),
                    onChanged: (v) => setState(() => _selectedCommission = v!),
                  ),
                  const SizedBox(height: 16),

                  // ROLE
                  _buildLabel('Rôle'),
                  DropdownButtonFormField<EntityResponsibleRole>(
                    initialValue: _selectedRole,
                    decoration: _inputDecoration('', null),
                    items: EntityResponsibleRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r == EntityResponsibleRole.responsable ? 'Responsable' : 'Suppléant'))).toList(),
                    onChanged: (v) => setState(() => _selectedRole = v!),
                  ),
                  
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Se connecter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: () {}, child: const Text('Mot de passe oublié ?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
                      const SizedBox(height: 20, child: VerticalDivider()),
                      TextButton(onPressed: () => context.go('/register'), child: const Text('Créer un nouveau compte', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF003366)) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  String _getLevelLabel(EntityLevel l) {
    switch (l) {
      case EntityLevel.communaute: return 'Communauté';
      case EntityLevel.district: return 'District';
      case EntityLevel.champ: return 'Champ';
      case EntityLevel.regionApostolique: return 'Région Apostolique';
      case EntityLevel.territoriale: return 'Territoriale';
      case EntityLevel.internationale: return 'Internationale';
    }
  }

  String _getRoleLabel(UserRole r) {
    switch (r) {
      case UserRole.apotrePatriarche: return 'Apôtre Patriarche';
      case UserRole.apotreDistrict: return 'Apôtre de District';
      case UserRole.apotreResponsable: return 'Apôtre Responsable';
      case UserRole.apotre: return 'Apôtre';
      case UserRole.eveque: return 'Évêque';
      case UserRole.ancien: return 'Ancien';
      case UserRole.lead: return 'Lead';
      case UserRole.berger: return 'Berger';
      case UserRole.evangeliste: return 'Évangéliste';
      case UserRole.pretre: return 'Prêtre';
      case UserRole.diacre: return 'Diacre';
      case UserRole.sousDiacre: return 'Sous-Diacre';
      case UserRole.frereCharge: return 'Frère Chargé';
      case UserRole.conductrice: return 'Conductrice';
      case UserRole.membre: return 'Membre';
      default: return 'Autre';
    }
  }

  String _getCommLabel(CommissionType c) {
    switch (c) {
      case CommissionType.ecodim: return 'Ecodim';
      case CommissionType.econfi: return 'Econfi';
      case CommissionType.jeunesse: return 'Jeunesse';
      case CommissionType.papas: return 'Papas';
      case CommissionType.mamans: return 'Mamans';
      case CommissionType.aines: return 'Aînés';
      case CommissionType.musique: return 'Musique';
      case CommissionType.presseMediasSonorisation: return 'Presse & Médias';
      case CommissionType.josephArimathee: return 'Joseph d\'Arimathée';
      case CommissionType.securiteProtocole: return 'Sécurité';
      case CommissionType.medicale: return 'Médicale';
      case CommissionType.construction: return 'Construction';
      case CommissionType.sacristie: return 'Sacristie';
      case CommissionType.none: return 'Aucune (Ministre)';
    }
  }
}
