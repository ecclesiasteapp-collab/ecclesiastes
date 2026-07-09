import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/member_model.dart';
import 'member_detail_screen.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Répertoire des Membres'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un membre...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<MemberModel>('member_profiles').listenable(),
              builder: (context, Box<MemberModel> box, _) {
                final members = box.values.where((m) {
                  final fullName = '${m.nom} ${m.postNom} ${m.prenom}'.toLowerCase();
                  return fullName.contains(_searchQuery);
                }).toList();

                if (members.isEmpty) {
                  return const Center(child: Text('Aucun membre trouvé.'));
                }

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF003366),
                          child: Text(
                            member.nom[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text('${member.nom.toUpperCase()} ${member.prenom}'),
                        subtitle: Text('${member.statutMembre} - ${member.communityName}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberDetailScreen(member: member),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
