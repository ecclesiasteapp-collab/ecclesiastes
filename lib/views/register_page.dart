import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../models/hierarchy_models.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedChamp;
  String? _selectedDistrict;
  String? _selectedCommunity;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  List<dynamic> _champs = [];
  List<dynamic> _districts = [];
  List<dynamic> _communities = [];

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    try {
      final champsData = await rootBundle.loadString('assets/config/kso_youth.json');
      final champsJson = json.decode(champsData);
      if (champsJson == null) {
        return;
      }
      // Adaptation selon la structure de kso_youth.json ou kso.json
      setState(() {
        _champs = [{'id': 'champ_kso', 'name': 'Kinshasa Sud-Ouest (KSO)'}];
      });
    } catch (e) {
      debugPrint('Erreur chargement entités: $e');
    }
  }

  void _onChampSelected(String champId) {
    setState(() {
      _selectedChamp = champId;
      _selectedDistrict = null;
      _selectedCommunity = null;
      _districts = [];
      _communities = [];
    });
    _loadDistricts(champId);
  }

  Future<void> _loadDistricts(String champId) async {
    // Simulation simplifiée
    setState(() {
      _districts = [
        {'id': 'dist_ngomba', 'name': 'Ngomba Kinkusa'},
        {'id': 'dist_bileko', 'name': 'Bileko'},
        {'id': 'dist_sarepta', 'name': 'Sarepta'},
        {'id': 'dist_malueka', 'name': 'Malueka'},
      ];
    });
  }

  void _onDistrictSelected(String districtId) {
    setState(() {
      _selectedDistrict = districtId;
      _selectedCommunity = null;
      _communities = [];
    });
    _loadCommunities(districtId);
  }

  Future<void> _loadCommunities(String districtId) async {
    final Map<String, List<Map<String, String>>> communitiesMap = {
      'dist_ngomba': [
        {'id': 'com_ane', 'name': 'ANE'},
        {'id': 'com_buania', 'name': 'Buania'},
      ],
      'dist_bileko': [
        {'id': 'com_bileko', 'name': 'Bileko'},
      ],
    };

    setState(() {
      _communities = communitiesMap[districtId] ?? [];
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCommunity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner votre communauté'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // --- LOGIQUE D'INSCRIPTION LIBRE (NE PAS MODIFIER SANS ACCORD) ---
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        passwordHash: User.hashPassword(_passwordController.text),
        role: UserRole.membre, // Inscription libre = Membre par défaut
        entityId: _selectedCommunity!,
        entityLevel: EntityLevel.communaute,
        status: 'pending', // En attente de validation par le responsable
        isActive: false,
        createdAt: DateTime.now(),
        pendingSince: DateTime.now(),
      );

      await AuthService.registerPendingUser(user);

      if (mounted) {
        context.go('/pending-confirmation', extra: {
          'email': user.email,
          'entityName': _getSelectedEntityName(),
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getSelectedEntityName() {
    final community = _communities.firstWhere((c) => c['id'] == _selectedCommunity, orElse: () => {'name': 'Inconnue'});
    return community['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Créer un compte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  const SizedBox(height: 8),
                  Text('Rejoignez l\'Église Néo-Apostolique KSO', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Nom complet', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.isEmpty) ? 'Nom requis' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.length < 9) ? 'Numéro invalide' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? '6 caractères minimum' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v != _passwordController.text ? 'Mots de passe différents' : null,
                  ),
                  const SizedBox(height: 24),

                  const Text('Votre entité de rattachement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Champ Apostolique', border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_balance)),
                    initialValue: _selectedChamp,
                    items: _champs.map((c) => DropdownMenuItem(value: c['id'] as String, child: Text(c['name'] as String))).toList(),
                    onChanged: (v) => _onChampSelected(v!),
                    validator: (v) => v == null ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'District', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city)),
                    initialValue: _selectedDistrict,
                    items: _districts.map((d) => DropdownMenuItem(value: d['id'] as String, child: Text(d['name'] as String))).toList(),
                    onChanged: _selectedChamp == null ? null : (v) => _onDistrictSelected(v!),
                    validator: (v) => v == null ? 'District requis' : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Communauté', border: OutlineInputBorder(), prefixIcon: Icon(Icons.church)),
                    initialValue: _selectedCommunity,
                    items: _communities.map((c) => DropdownMenuItem(value: c['id'] as String, child: Text(c['name'] as String))).toList(),
                    onChanged: _selectedDistrict == null ? null : (v) => setState(() => _selectedCommunity = v),
                    validator: (v) => v == null ? 'Communauté requise' : null,
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Votre inscription sera validée par le responsable sous 3 à 4 jours', style: TextStyle(fontSize: 12, color: Color(0xFF003366)))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Créer mon compte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Déjà un compte ?'),
                      TextButton(onPressed: () => context.go('/login'), child: const Text('Se connecter')),
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
}

