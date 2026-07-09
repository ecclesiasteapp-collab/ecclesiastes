import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _communityController = TextEditingController();
  final _box = Hive.box('settings');

  @override
  void initState() {
    super.initState();
    _nameController.text = _box.get('userName', defaultValue: 'Utilisateur');
    _communityController.text = _box.get('communityName', defaultValue: 'Ma Communauté');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _communityController.dispose();
    super.dispose();
  }

  void _save() {
    _box.put('userName', _nameController.text);
    _box.put('communityName', _communityController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Votre Nom'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _communityController,
              decoration: const InputDecoration(labelText: 'Nom de la Communauté'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Enregistrer'),
            )
          ],
        ),
      ),
    );
  }
}
