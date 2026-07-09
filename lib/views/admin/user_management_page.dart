import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../services/repository_providers.dart';
import '../../services/auth_service.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<User> _activeUsers = [];
  List<User> _pendingUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final repo = ref.read(userRepositoryProvider);
    
    final active = await repo.getAllUsers();
    final pending = await repo.getPendingUsers();
    
    if (mounted) {
      setState(() {
        _activeUsers = active;
        _pendingUsers = pending;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Actifs (${_activeUsers.length})'),
            Tab(text: 'En attente (${_pendingUsers.length})'),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
              _buildUserList(_activeUsers, isPending: false),
              _buildUserList(_pendingUsers, isPending: true),
            ],
          ),
    );
  }

  Widget _buildUserList(List<User> users, {required bool isPending}) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isPending ? 'Aucune demande en attente' : 'Aucun utilisateur actif', 
                 style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF003366),
              child: Text(user.fullName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.identifiant),
                Text('Rôle: ${user.role.name}'),
                Text('Entité: ${user.entityId}'),
              ],
            ),
            trailing: isPending 
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () => _validateUser(user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _rejectUser(user),
                    ),
                  ],
                )
              : PopupMenuButton<String>(
                  onSelected: (val) => _handleAction(val, user),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit_role', child: Text('Modifier le rôle')),
                    const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
                  ],
                ),
          ),
        );
      },
    );
  }

  Future<void> _validateUser(User user) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.validateUser(user.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utilisateur ${user.fullName} validé'), backgroundColor: Colors.green)
    );
    _loadData();
  }

  Future<void> _rejectUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rejeter'),
        content: Text('Voulez-vous rejeter la demande de ${user.fullName} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Rejeter', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(userRepositoryProvider);
      await repo.rejectUser(user.id);
      _loadData();
    }
  }

  void _handleAction(String action, User user) {
    if (action == 'delete') _deleteUser(user);
    if (action == 'edit_role') _editRole(user);
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Supprimer définitivement ${user.fullName} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(userRepositoryProvider);
      await repo.deleteUser(user.id);
      _loadData();
    }
  }

  Future<void> _editRole(User user) async {
    // Basic role selector
    final UserRole? newRole = await showDialog<UserRole>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choisir un nouveau rôle'),
        children: UserRole.values.map((r) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, r),
          child: Text(r.name),
        )).toList(),
      ),
    );

    if (newRole != null) {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateUserRole(user.id, newRole);
      _loadData();
    }
  }
}
