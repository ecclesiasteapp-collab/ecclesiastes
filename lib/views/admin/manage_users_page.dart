import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/database_helper.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}
class _ManageUsersPageState extends State<ManageUsersPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _pendingUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final activeUsersFuture = DatabaseHelper.instance.getAllUtilisateurs();
    final pendingUsersFuture = DatabaseHelper.instance.getUtilisateursEnAttente();

    final results = await Future.wait([activeUsersFuture, pendingUsersFuture]);

    if (!mounted) {
      return;
    }
    setState(() {
      _users = results[0];
      _pendingUsers = results[1];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) {
      return _users;
    }
    final query = _searchQuery.toLowerCase();
    return _users.where((u) {
      final name = u['full_name']?.toString().toLowerCase() ?? '';
      final identifiant = u['identifiant']?.toString().toLowerCase() ?? '';
      return name.contains(query) || identifiant.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredPendingUsers {
    if (_searchQuery.isEmpty) {
      return _pendingUsers;
    }
    final query = _searchQuery.toLowerCase();
    return _users.where((u) {
      final name = u['full_name']?.toString().toLowerCase() ?? '';
      final identifiant = u['identifiant']?.toString().toLowerCase() ?? '';
      return name.contains(query) || identifiant.contains(query);
    }).toList();
  }

  void _editUser(Map<String, dynamic> user) {
    final TextEditingController nameController = TextEditingController(
      text: user['full_name'],
    );
    String selectedRole = user['role']?.toString() ?? '';
    String selectedStatus = user['status']?.toString() ?? 'active';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Modifier ${user['full_name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom complet'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              items: ['ADMIN', 'MINISTRE', 'MEMBRE', 'SUPER_ADMIN']
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedRole = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Rôle'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              items: ['active', 'suspended', 'pending']
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Statut du compte'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final updatedUser = Map<String, dynamic>.from(user);
              updatedUser['full_name'] = nameController.text;
              updatedUser['role'] = selectedRole;
              updatedUser['status'] = selectedStatus;

              await DatabaseHelper.instance.updateUtilisateur(user['id'], updatedUser);
              if (!mounted) {
                return;
              }
              navigator.pop();
              if (!mounted) {
                return;
              }
              _loadUsers();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Supprimer l'utilisateur"),
        content: Text(
          'Voulez-vous vraiment supprimer ${user['full_name']} ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              await DatabaseHelper.instance.supprimerUtilisateur(user['id']);
              if (!mounted) {
                return;
              }
              navigator.pop();
              if (!mounted) {
                return;
              }
              _loadUsers();
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateUser(String userId) async {
    await DatabaseHelper.instance.validerUtilisateur(userId);
    _loadUsers();
  }

  Future<void> _rejectUser(String userId) async {
    await DatabaseHelper.instance.supprimerUtilisateur(userId);
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: 'UTILISATEURS ACTIFS'), Tab(text: 'EN ATTENTE')],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un utilisateur',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet des utilisateurs actifs
                _buildUserList(_filteredUsers, isActive: true),
                // Onglet des utilisateurs en attente
                _buildUserList(_filteredPendingUsers, isActive: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ajouter un nouvel utilisateur
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users, {required bool isActive}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (users.isEmpty) {
      return Center(
        child: Text(isActive ? 'Aucun utilisateur actif trouvé.' : 'Aucun utilisateur en attente.'),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final fullName = user['full_name']?.toString() ?? 'Sans nom';
        return ListTile(
          leading: CircleAvatar(
            child: Text(fullName.isNotEmpty ? fullName[0] : 'U'),
          ),
          title: Text(fullName),
          subtitle: Text('${user['role']} - ${user['identifiant']}'),
          trailing: isActive
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editUser(user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteUser(user),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _validateUser(user['id'])),
                    IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => _rejectUser(user['id'])),
                  ],
                ),
        );
      },
    );
  }
}

