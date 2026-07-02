import 'package:flutter/material.dart';
import 'package:ecclesiastes/config/ministerial_ranks_config.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/utils/entite_types.dart';
import 'package:ecclesiastes/config/organization_config.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:go_router/go_router.dart';

class HierarchiePage extends StatefulWidget {
  final String? parentId;
  final String title;
  final String typeEntite;

  const HierarchiePage({
    super.key,
    this.parentId,
    this.title = 'Hiérarchie Ecclésiaste',
    this.typeEntite = EntiteTypes.racine,
  });

  @override
  State<HierarchiePage> createState() => _HierarchiePageState();
}

class _HierarchiePageState extends State<HierarchiePage> {
  List<Map<String, dynamic>> _entites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntites();
  }

  Future<void> _loadEntites() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final childType = EntiteTypes.enfantDe(widget.typeEntite);
      if (childType == null) {
        if (mounted) setState(() => _entites = []);
        return;
      }

      final parentId = widget.typeEntite == EntiteTypes.racine ? null : widget.parentId;
      final data = await DatabaseHelper.instance.getSubEntites(parentId, childType);

      final normalized = data
          .map((e) => {...e, 'type': EntiteTypes.normalize(e['type']?.toString())})
          .toList();

      if (mounted) setState(() => _entites = normalized);
    } catch (e) {
      debugPrint('Erreur hiérarchie : $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  IconData _iconForType(String type) {
    switch (EntiteTypes.normalize(type)) {
      case EntiteTypes.internationale:
        return Icons.public;
      case EntiteTypes.egliseTerritoriale:
        return Icons.account_balance;
      case EntiteTypes.champApostolique:
        return Icons.language;
      case EntiteTypes.district:
        return Icons.corporate_fare;
      case EntiteTypes.communaute:
        return Icons.location_city;
      default:
        return Icons.account_tree;
    }
  }

  void _showApostleProfile(BuildContext context, String nomEntite, String roleCode) {
    final apostleDefinition =
        MinisterialRanksConfig.findByRole(_mapRoleCode(roleCode));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil du Responsable'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle, color: Color(0xFF003366), size: 40),
                title: Text(nomEntite),
                subtitle: Text(apostleDefinition?.label ?? 'Responsable'),
              ),
              const Divider(),
              Text(
                apostleDefinition?.roleDescription ??
                    'Le responsable veille à la direction spirituelle et administrative de l’entité.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              if (apostleDefinition != null) ...[
                const Text(
                  'Principales tâches',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final task in apostleDefinition.tasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $task', style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
      ),
    );
  }

  UserRole _mapRoleCode(String roleCode) {
    return UserRole.values.firstWhere(
      (r) => r.name.toLowerCase() == roleCode.toLowerCase(),
      orElse: () => UserRole.membre,
    );
  }

  Color _colorForType(String type) {
    switch (EntiteTypes.normalize(type)) {
      case EntiteTypes.internationale:
        return Colors.purple;
      case EntiteTypes.egliseTerritoriale:
        return Colors.indigo;
      case EntiteTypes.champApostolique:
        return Colors.teal;
      case EntiteTypes.district:
        return Colors.orange;
      case EntiteTypes.communaute:
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  void _showCommissionsBottomSheet(BuildContext context, String entiteId, String nomEntite) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF003366),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  const Text('RESPONSABLES DES COMMISSIONS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(nomEntite, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.instance.getCommissionResponsables(entiteId: entiteId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final commissions = snapshot.data!;
                  if (commissions.isEmpty) {
                    return const Center(
                      child: Text('Aucune commission configurée pour cette communauté.'),
                    );
                  }

                  return ListView.separated(
                    controller: controller,
                    itemCount: commissions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final commissionData = commissions[index];
                      final commissionType = commissionData['commission_type']?.toString();
                      final commission = OrganizationConfig.commissions.firstWhere(
                        (item) => item.type.name == commissionType,
                        orElse: () => const CommissionDefinition(
                          type: CommissionType.none,
                          name: 'Commission',
                          description: '',
                          code: 'UNKNOWN',
                        ),
                      );
                      final responsableNom =
                          commissionData['responsable_nom']?.toString() ?? 'À désigner';
                      final adjointNom =
                          commissionData['adjoint_nom']?.toString() ?? 'À désigner';
                      final sousCommissions =
                          (commissionData['sous_commissions'] as List?)?.cast<String>() ??
                              commission.sousCommissions;

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.group, color: Colors.white, size: 20),
                        ),
                        title: Text(
                          commissionData['commission_nom']?.toString() ?? commission.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text(
                          sousCommissions.isEmpty
                              ? 'Responsable : $responsableNom\nAdjoint : $adjointNom'
                              : 'Responsable : $responsableNom\nAdjoint : $adjointNom\nSous-commissions : ${sousCommissions.join(', ')}',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/members', extra: {
                            'communauteId': entiteId,
                            'commission': commission.type.name,
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final childLabel = EntiteTypes.enfantDe(widget.typeEntite);
    final emptyHint = childLabel != null
        ? 'Aucun ${EntiteTypes.label(childLabel).toLowerCase()} sous ${widget.title}'
        : 'Aucune sous-entité';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Retour',
            )
          : null,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _entites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_tree_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(emptyHint, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _entites.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemBuilder: (context, index) {
                    final entite = _entites[index];
                    final id = entite['id']?.toString() ?? '';
                    final nom = entite['nom']?.toString() ?? 'Sans nom';
                    final type = EntiteTypes.normalize(entite['type']?.toString());
                    final responsable = entite['responsable_nom']?.toString() ?? 'À définir';
                    final roleCode = entite['responsable_role']?.toString() ?? 'membre';
                    final color = _colorForType(type);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.12),
                          child: Icon(_iconForType(type), color: color),
                        ),
                        title: Text(nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Text(
                          '${EntiteTypes.label(type)} • Responsable : $responsable',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            if (type == EntiteTypes.internationale || type == EntiteTypes.egliseTerritoriale || type == EntiteTypes.champApostolique)
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.blue),
                                onPressed: () => _showApostleProfile(context, nom, roleCode),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            Icon(
                              EntiteTypes.peutNaviguerVersEnfants(type)
                                  ? Icons.arrow_forward_ios
                                  : Icons.group_work_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (type == EntiteTypes.communaute) {
                            _showCommissionsBottomSheet(context, id, nom);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HierarchiePage(
                                  parentId: id,
                                  title: '${EntiteTypes.label(type)} : $nom',
                                  typeEntite: type,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

