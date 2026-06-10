import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nomController = TextEditingController();
  final _identifiantController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, dynamic>> _communautes = [];
  String? _communauteId;
  String? _ministere;
  String? _role;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chargerCommunautes();
  }

  Future<void> _chargerCommunautes() async {
    final data = await DatabaseHelper.instance.getCommunautesAvecChemin();
    if (mounted) setState(() => _communautes = data);
  }

  Future<void> _creerCompte() async {
    if (_communauteId == null || _role == null) {
      _msg('Veuillez remplir tous les champs obligatoires.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final success = await AuthService().register(
        fullName: _nomController.text.trim(),
        email: _identifiantController.text.trim(),
        password: _passwordController.text,
        role: _role == 'Responsable d\'entité' ? UserRole.chefCommunaute : UserRole.membre,
        entityLevel: 'COMMUNAUTE',
        entityId: _communauteId!,
      );
      
      if (!mounted) return;
      if (success) {
        Navigator.pop(context);
        _msg('Compte créé avec succès !');
      } else {
        _msg('Cet identifiant est déjà utilisé.');
      }
    } catch (e) {
      _msg('Erreur lors de la création.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Compte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _identifiantController, decoration: const InputDecoration(labelText: 'Identifiant / Email', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            
            _simpleDropdown(
              label: 'Niveau (Communauté)',
              value: _communauteId,
              items: _communautes.map((c) => DropdownMenuItem<String>(
                value: c['id'] as String,
                child: Text(c['chemin'] as String, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (v) => setState(() => _communauteId = v),
            ),
            const SizedBox(height: 16),
            _simpleDropdown(
              label: 'Ministère',
              value: _ministere,
              items: AppConstants.ministeres.map((m) => DropdownMenuItem<String>(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _ministere = v),
            ),
            const SizedBox(height: 16),
            _simpleDropdown(
              label: 'Rôle Applicatif',
              value: _role,
              items: AppConstants.rolesConnexion.map((r) => DropdownMenuItem<String>(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => _role = v),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _creerCompte,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Créer mon compte'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleDropdown({required String label, required String? value, required List<DropdownMenuItem<String>> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      isExpanded: true,
      items: items,
      onChanged: onChanged,
    );
  }
}
