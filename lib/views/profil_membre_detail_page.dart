import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecclesiaste/models/member_profile.dart';

class ProfilMembreDetailPage extends StatelessWidget {
  final String memberId;
  const ProfilMembreDetailPage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<MemberProfile>('member_profiles');
    final member = box.get(memberId);

    if (member == null) {
      return const Scaffold(body: Center(child: Text('Membre introuvable')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche Pastorale'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF003366),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const CircleAvatar(
                      radius: 50, child: Icon(Icons.person, size: 50)),
                  const SizedBox(height: 12),
                  Text('${member.nom} ${member.prenom}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const Text('ID: #MEM-2026-X',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSacramentSection(member),
                  const SizedBox(height: 24),
                  _buildInfoSection('Coordonnées', [
                    {'label': 'Téléphone', 'value': member.telephone},
                    {'label': 'Adresse', 'value': 'Q. Jolie Parc, Nsele'},
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSacramentSection(MemberProfile member) {
    String formatDate(DateTime? d) =>
        d != null ? '${d.day}/${d.month}/${d.year}' : 'Non renseignée';

    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VIE SACRAMENTELLE',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            Divider(),
            ListTile(
                leading: Icon(Icons.water_drop, color: Colors.blue),
                title: Text('Baptême Saint'),
                subtitle: Text('Date : ${formatDate(member.dateBapteme)}')),
            ListTile(
                leading: Icon(Icons.wb_sunny, color: Colors.orange),
                title: Text('Saint-Scellement'),
                subtitle: Text('Date : ${formatDate(member.dateScellement)}')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Map<String, String>> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...fields.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Text('${f['label']} : ',
                    style: const TextStyle(color: Colors.grey)),
                Text(f['value']!)
              ]),
            )),
      ],
    );
  }
}

