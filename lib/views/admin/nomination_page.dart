import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/services/nomination_service.dart';
import 'package:ecclesiastes/services/database_helper.dart';

class NominationPage extends StatefulWidget {
  final EntityLevel targetLevel;
  const NominationPage({super.key, required this.targetLevel});

  @override
  State<NominationPage> createState() => _NominationPageState();
}

class _NominationPageState extends State<NominationPage> {
  List<Map<String, dynamic>> _eligibleUsers = [];
  List<Map<String, dynamic>> _entities = [];
  bool _isLoading = true;
  
  String? _selectedUserId;
  String? _selectedEntityId;
  bool _isAdjoint = false;
  bool _isInterim = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final users = await DatabaseHelper.instance.getAllUtilisateurs();
    
    String typeSearch = '';
    switch (widget.targetLevel) {
      case EntityLevel.territoriale: typeSearch = 'EGLISE_TERRITORIALE'; break;
      case EntityLevel.district: typeSearch = 'DISTRICT'; break;
      case EntityLevel.communaute: typeSearch = 'COMMUNAUTE'; break;
      default: typeSearch = widget.targetLevel.name;
    }
    
    final entities = await DatabaseHelper.instance.getEntitesByType(typeSearch);
    
    setState(() {
      _eligibleUsers = users;
      _entities = entities;
      _isLoading = false;
    });
  }

  Future<void> _submitNomination() async {
    if (_selectedUserId == null || _selectedEntityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un ministre et une entité')),
      );
      return;
    }

    try {
      await NominationService.nominate(
        targetUserId: _selectedUserId!,
        level: widget.targetLevel,
        entityId: _selectedEntityId!,
        isAdjoint: _isAdjoint,
        isInterim: _isInterim,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomination effectuée avec succès')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nomination : ${widget.targetLevel.name.toUpperCase()}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Sélectionner le Ministre', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedUserId,
                    items: _eligibleUsers.map<DropdownMenuItem<String>>((u) => DropdownMenuItem<String>(
                      value: u['identifiant']?.toString(),
                      child: Text(u['full_name']?.toString() ?? 'Inconnu'),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedUserId = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('2. Sélectionner l\'Entité', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedEntityId,
                    items: _entities.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                      value: e['id']?.toString(),
                      child: Text(e['nom']?.toString() ?? 'Sans nom'),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedEntityId = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  
                  SwitchListTile(
                    title: const Text('Nommer comme Adjoint / Suppléant'),
                    subtitle: const Text('L\'utilisateur sera le numéro 2 de l\'entité'),
                    value: _isAdjoint,
                    onChanged: (val) => setState(() => _isAdjoint = val),
                  ),
                  
                  SwitchListTile(
                    title: const Text('Assumer un Intérim'),
                    subtitle: const Text('Statut temporaire de remplacement'),
                    value: _isInterim,
                    onChanged: (val) => setState(() => _isInterim = val),
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitNomination,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                      child: const Text('CONFIRMER LA NOMINATION'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

