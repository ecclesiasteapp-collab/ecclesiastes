import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003366),
              Color(0xFF001a33),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF003366), width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/logos/logo_accueil.png',
                            height: 80,
                            width: 80,
                            errorBuilder: (ctx, _, __) => const Icon(Icons.church, size: 60, color: Color(0xFF003366)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Ecclésiaste', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                        const Text('Connectez-vous à votre communauté', style: TextStyle(color: Colors.black54, fontSize: 14)),
                        const SizedBox(height: 24),

                        // EMAIL
                        _buildLabel('Email ou Identifiant'),
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration('nom@ena.org', Icons.alternate_email),
                          validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                        ),
                        const SizedBox(height: 16),

                        // PASSWORD
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

                        // DROPDOWNS en format compact
                        Row(
                          children: [
                            Expanded(child: _buildCompactDropdown('Niveau', EntityLevel.values, _selectedNiveau, (v) => _selectedNiveau = v!)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildCompactDropdown('Rôle', EntityResponsibleRole.values, _selectedRole, (v) => _selectedRole = v!)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildCompactDropdown('Ministère', UserRole.values.take(15).toList(), _selectedMinistere, (v) => _selectedMinistere = v!),
                        const SizedBox(height: 16),
                        _buildCompactDropdown('Commission', CommissionType.values, _selectedCommission, (v) => _selectedCommission = v!),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003366),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('SE CONNECTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: () => context.go('/register'), child: const Text('Créer un compte', style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold))),
                            const Text(' • ', style: TextStyle(color: Colors.grey)),
                            TextButton(onPressed: () => context.go('/legal'), child: const Text('CGU', style: TextStyle(color: Colors.grey))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF003366))),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF003366), size: 18) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
    );
  }

  Widget _buildCompactDropdown<T>(String label, List<T> items, T value, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: _inputDecoration('', null),
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(_getLabel(item), style: const TextStyle(fontSize: 12)),
          )).toList(),
          onChanged: (v) => setState(() => onChanged(v)),
        ),
      ],
    );
  }

  String _getLabel(dynamic item) {
    if (item is EntityLevel) {
      switch (item) {
        case EntityLevel.communaute: return 'Communauté';
        case EntityLevel.district: return 'District';
        case EntityLevel.champ: return 'Champ';
        case EntityLevel.regionApostolique: return 'Région Apostolique';
        case EntityLevel.territoriale: return 'Territoriale';
        case EntityLevel.internationale: return 'Internationale';
      }
    }
    if (item is UserRole) {
      switch (item) {
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
    if (item is CommissionType) {
      switch (item) {
        case CommissionType.ecodim: return 'Ecodim';
        case CommissionType.econfi: return 'Econfi';
        case CommissionType.jeunesse: return 'Jeunesse';
        case CommissionType.papas: return 'Papas';
        case CommissionType.mamans: return 'Mamans';
        case CommissionType.aines: return 'Aînés';
        case CommissionType.musique: return 'Musique';
        case CommissionType.presseMediasSonorisation: return 'Presse';
        case CommissionType.josephArimathee: return 'Arimathée';
        case CommissionType.securiteProtocole: return 'Sécurité';
        case CommissionType.medicale: return 'Médicale';
        case CommissionType.construction: return 'Construction';
        case CommissionType.sacristie: return 'Sacristie';
        case CommissionType.none: return 'Aucune (Ministre)';
      }
    }
    if (item is EntityResponsibleRole) {
      return item == EntityResponsibleRole.responsable ? 'Responsable' : 'Suppléant';
    }
    return item.toString();
  }
}
