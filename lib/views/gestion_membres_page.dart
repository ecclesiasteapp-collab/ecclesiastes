import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/member_profile.dart';

class GestionMembresPage extends StatefulWidget {
  final String? commissionName;
  final String? entiteId;

  const GestionMembresPage({
    super.key,
    this.commissionName,
    this.entiteId,
  });

  @override
  State<GestionMembresPage> createState() => _GestionMembresPageState();
}

class _GestionMembresPageState extends State<GestionMembresPage> {
  late Box<MemberProfile> _memberBox;
  List<MemberProfile> _members = [];
  List<MemberProfile> _filteredMembers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    _memberBox = Hive.box<MemberProfile>('member_profiles');

    List<MemberProfile> list = _memberBox.values.toList();

    // Application des filtres initiaux (Commission / Entité)
    if (widget.commissionName != null) {
      // Note: On suppose que le profil membre a un champ commission ou similaire
      // Si ce n'est pas le cas, on ignore ou on adapte.
    }

    if (widget.entiteId != null) {
      list = list.where((m) => m.communauteId == widget.entiteId).toList();
    }

    setState(() {
      _members = list;
      _filteredMembers = _members;
      _isLoading = false;
    });
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _members.where((member) {
        final fullName = '${member.prenom} ${member.nom}'.toLowerCase();
        return fullName.contains(query) ||
            (member.email?.toLowerCase().contains(query) ?? false) ||
            member.telephone.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: Text(widget.commissionName ?? 'Gestion des Membres'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/member/register'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un membre...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMembers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text('Aucun membre trouvé',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredMembers.length,
                        itemBuilder: (context, index) =>
                            _buildMemberCard(_filteredMembers[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/member/register'),
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMemberCard(MemberProfile member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF003366),
          child: Text(
            member.nom.isNotEmpty ? member.nom[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${member.prenom} ${member.nom}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (member.email != null) Text(member.email!),
            Text(member.telephone),
            Text('Statut: ${member.statutMembre.name}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, member),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('Voir')),
            const PopupMenuItem(value: 'edit', child: Text('Modifier')),
            const PopupMenuItem(
                value: 'delete',
                child: Text('Supprimer', style: TextStyle(color: Colors.red))),
          ],
        ),
        onTap: () => _viewMemberDetails(member),
      ),
    );
  }

  void _handleMenuAction(String action, MemberProfile member) {
    switch (action) {
      case 'view':
        _viewMemberDetails(member);
        break;
      case 'edit':
        context.go('/member/edit/${member.id}');
        break;
      case 'delete':
        _deleteMember(member);
        break;
    }
  }

  void _viewMemberDetails(MemberProfile member) {
    context.go('/member/detail/${member.id}');
  }

  Future<void> _deleteMember(MemberProfile member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text('Supprimer ${member.prenom} ${member.nom} ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _memberBox.delete(member.id);
      _loadMembers();
    }
  }
}

