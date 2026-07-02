// lib/screens/champ/kso_districts_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/district_model.dart';

class KsoDistrictsScreen extends StatelessWidget {
  const KsoDistrictsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Districts du Champ KSO'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un district...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                // Pour simplifier, nous utilisons un ValueNotifier ou setState
                // mais ici le ValueListenableBuilder reconstruit tout.
                // Une approche plus avancée serait un filtrage local.
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<DistrictModel>('districts').listenable(),
              builder: (context, Box<DistrictModel> box, _) {
                final districts = box.values.toList()
                  ..sort((a, b) => a.name.compareTo(b.name));

                if (districts.isEmpty) {
                  return const Center(child: Text('Aucun district trouvé.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF003366),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(district.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${district.communitiesCount} communautés • ${district.membersCount} membres'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DistrictDetailScreen(district: district),
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

// Nouvel écran de détail
class DistrictDetailScreen extends StatelessWidget {
  final DistrictModel district;
  const DistrictDetailScreen({super.key, required this.district});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(district.name),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoTile(Icons.location_on, 'Siège', district.siege),
          _buildInfoTile(
              Icons.church, 'Communautés', '${district.communitiesCount}'),
          _buildInfoTile(Icons.people, 'Membres', '${district.membersCount}'),
          const Divider(),
          const Text('Responsables',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Affichage des responsables stockés dans le modèle
          ...district.responsables.map((r) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(r),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF003366)),
        title: Text(title),
        trailing: Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

