import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../models/nomination_model.dart';
import '../../models/person_model.dart';
import '../../services/repository_providers.dart';
import '../../widgets/dashboard/entite_hierarchy_pills.dart';
import '../../widgets/dashboard/dashboard_shared.dart';
import '../../providers/scope_provider.dart';
import '../../services/database_helper.dart';
import '../../config/organization_config.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class GovernanceDashboardPage extends ConsumerStatefulWidget {
  const GovernanceDashboardPage({super.key});

  @override
  ConsumerState<GovernanceDashboardPage> createState() => _GovernanceDashboardPageState();
}

class _GovernanceDashboardPageState extends ConsumerState<GovernanceDashboardPage> {
  List<Nomination> _nominations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entityId = ref.read(activeEntityIdProvider);
    final govRepo = ref.read(governanceRepositoryProvider);
    
    // Récupérer les nominations pour l'entité active
    final noms = await govRepo.getNominationsForEntity(entityId);
    
    if (mounted) {
      setState(() {
        _nominations = noms;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Gestion de la Gouvernance',
      subtitle: 'Mandats et Nominations',
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: EntiteHierarchyPills(
              onScopeChanged: () => _loadData(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _buildNominationsList(),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
        ),
      ],
    );
  }

  Widget _buildNominationsList() {
    if (_nominations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_ind_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('Aucun responsable nommé pour cette entité', 
              style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddNominationDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Nommer un responsable'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Responsables Actuels', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            TextButton.icon(
              onPressed: () => _showAddNominationDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._nominations.map((n) => _buildNominationCard(n)),
        const SizedBox(height: 24),
        _buildVacantPositionsSection(),
      ],
    );
  }

  Widget _buildNominationCard(Nomination nomination) {
    return FutureBuilder<Person?>(
      future: ref.read(memberRepositoryProvider).getMemberAsPerson(nomination.personId),
      builder: (context, snapshot) {
        final person = snapshot.data;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              child: const Icon(Icons.person, color: AppTheme.primary),
            ),
            title: Text(person?.fullName ?? 'Chargement...', 
              style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nomination.functionName, 
                  style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                Text('Depuis le ${nomination.startDate.toString().split(' ')[0]}', 
                  style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'end') _endNomination(nomination);
                if (val == 'delete') _deleteNomination(nomination);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'end', child: Text('Mettre fin au mandat')),
                const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVacantPositionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Postes Vacants (Suggérés)', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          color: Colors.orange.shade50,
          child: const ListTile(
            leading: Icon(Icons.warning_amber, color: Colors.orange),
            title: Text('Conducteur de Communauté'),
            subtitle: Text('Aucun titulaire actif détecté'),
            trailing: Icon(Icons.add_circle_outline, color: Colors.orange),
          ),
        ),
      ],
    );
  }

  void _endNomination(Nomination nomination) async {
    nomination.isActive = false;
    nomination.endDate = DateTime.now();
    await ref.read(governanceRepositoryProvider).saveNomination(nomination);
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mandat terminé')));
  }

  void _deleteNomination(Nomination nomination) async {
    await ref.read(governanceRepositoryProvider).deleteNomination(nomination.id);
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomination supprimée')));
  }

  void _showAddNominationDialog() async {
    final activeScope = EntiteScopeService.getActiveScope();
    final entityId = activeScope['id'];
    final level = activeScope['level'] as EntityLevel;

    // Si on est au sommet d'une entité, on peut créer l'entité du niveau inférieur en nommant son chef
    if (level != EntityLevel.communaute) {
      _showCreateSubEntityDialog(level, entityId);
      return;
    }

    // Cas spécifique de la communauté : on nomme des responsables internes (Secrétaire, Trésorier, etc.)
    final members = await ref.read(memberRepositoryProvider).getMembersByEntity(entityId);
    
    if (!mounted) return;

    if (members.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aucun membre'),
          content: const Text('Il n\'y a pas encore de membres inscrits dans cette communauté.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      return;
    }

    _showMemberPicker(members);
  }

  void _showCreateSubEntityDialog(EntityLevel currentLevel, String? parentId) {
    String subEntityLabel = '';
    String subEntityType = '';
    String roleLabel = '';
    String prefix = '';

    switch (currentLevel) {
      case EntityLevel.internationale:
        subEntityLabel = 'Église Territoriale';
        subEntityType = 'EGLISE_TERRITORIALE';
        roleLabel = 'Apôtre de District';
        prefix = 'terr';
        break;
      case EntityLevel.territoriale:
        subEntityLabel = 'Région Apostolique';
        subEntityType = 'REGION_APOSTOLIQUE';
        roleLabel = 'Apôtre Responsable';
        prefix = 'reg';
        break;
      case EntityLevel.regionApostolique:
        subEntityLabel = 'Champ Apostolique';
        subEntityType = 'CHAMP_APOSTOLIQUE';
        roleLabel = 'Apôtre';
        prefix = 'champ';
        break;
      case EntityLevel.champ:
        subEntityLabel = 'District';
        subEntityType = 'DISTRICT';
        roleLabel = 'Ancien de District';
        prefix = 'dist';
        break;
      case EntityLevel.district:
        subEntityLabel = 'Communauté';
        subEntityType = 'COMMUNAUTE';
        roleLabel = 'Conducteur (Recteur)';
        prefix = 'com';
        break;
      default: return;
    }

    final entityNameController = TextEditingController();
    final leaderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nouvelle $subEntityLabel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('La création d\'une $subEntityLabel est déclenchée par la nomination de son $roleLabel.', 
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: entityNameController,
              decoration: InputDecoration(labelText: 'Nom de la $subEntityLabel', hintText: 'ex: $subEntityLabel ...'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: leaderNameController,
              decoration: InputDecoration(labelText: 'Nom du $roleLabel'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (entityNameController.text.isEmpty || leaderNameController.text.isEmpty) return;

              final newEntityId = '${prefix}_${const Uuid().v4().substring(0, 8)}';
              
              // 1. Création de l'entité
              await DatabaseHelper.instance.insertEntite(
                id: newEntityId,
                nom: entityNameController.text,
                type: subEntityType,
                parentId: parentId,
              );

              // 2. Création de la nomination (activation de la gouvernance)
              final nominationId = const Uuid().v4();
              final nomination = Nomination(
                id: nominationId,
                personId: 'leader_${const Uuid().v4().substring(0, 8)}', 
                functionName: roleLabel,
                entityId: newEntityId,
                type: 'Titulaire',
                startDate: DateTime.now(),
              );
              await ref.read(governanceRepositoryProvider).saveNomination(nomination);

              // 3. Activation automatique des commissions pour la nouvelle entité
              await _activateCommissionsForEntity(newEntityId, subEntityType);

              if (mounted) {
                Navigator.pop(context);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$subEntityLabel ${entityNameController.text} créée avec ses commissions activées.'))
                );
              }
            },
            child: const Text('Créer et Nommer'),
          ),
        ],
      ),
    );
  }

  Future<void> _activateCommissionsForEntity(String entityId, String entityType) async {
    final commissionsBox = await Hive.openBox<Map>('commissions_map');
    
    // On récupère les types de commissions définis dans la config globale
    for (final config in OrganizationConfig.commissions) {
      final commissionId = const Uuid().v4();
      
      await commissionsBox.put(commissionId, {
        'id': commissionId,
        'entite_id': entityId,
        'entite_type': entityType,
        'commission_code': config.code,
        'commission_type': config.type.name,
        'commission_nom': config.name,
        'responsable_id': null,
        'responsable_nom': 'À désigner',
        'statut': 'active', // La commission est activée dès la création de l'entité
        'date_activation': DateTime.now().toIso8601String(),
      });
    }
  }

  void _showMemberPicker(List<MemberProfile> members) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionner un Membre'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final m = members[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('${m.prenom} ${m.nom}'),
                subtitle: Text(m.ecclesiasticalId ?? ''),
                onTap: () {
                  Navigator.pop(context);
                  _showNominationFormDialog(m);
                },
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler'))],
      ),
    );
  }

  void _showNominationFormDialog(MemberProfile m) {
    String functionName = '';
    String type = 'Titulaire';
    final dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Nommer ${m.prenom} ${m.nom}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom de la fonction (ex: Secrétaire)'),
                onChanged: (v) => functionName = v,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                items: ['Titulaire', 'Adjoint', 'Intérim'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setDialogState(() => type = v!),
                decoration: const InputDecoration(labelText: 'Type de mandat'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date d\'effet', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setDialogState(() => dateController.text = date.toString().split(' ')[0]);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (functionName.isEmpty) return;
                final nomination = Nomination(
                  id: const Uuid().v4(),
                  personId: m.id,
                  functionName: functionName,
                  entityId: ref.read(activeEntityIdProvider),
                  type: type,
                  startDate: DateTime.parse(dateController.text),
                );
                await ref.read(governanceRepositoryProvider).saveNomination(nomination);
                Navigator.pop(context);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomination enregistrée')));
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }
}

extension MemberRepositoryExt on MemberRepository {
  Future<Person?> getMemberAsPerson(String id) async {
    final member = await getMemberById(id);
    if (member == null) return null;
    return Person(
      id: member.id,
      ecclesiasticalId: member.id.substring(0, 8),
      lastName: member.nom,
      secondName: member.postNom,
      firstName: member.prenom,
      isMale: member.isMale,
      birthDate: member.dateNaissance,
      currentEntityId: member.communauteId,
    );
  }
}
