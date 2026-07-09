import 'package:flutter/material.dart';

class MinistersListView extends StatefulWidget {
  final String? entiteId;
  final String? entiteNom;
  const MinistersListView({super.key, this.entiteId, this.entiteNom});

  @override
  State<MinistersListView> createState() => _MinistersListViewState();
}

class _MinistersListViewState extends State<MinistersListView> {
  final List<Map<String, String>> _ministers = [
    {'nom': 'MBUYI', 'prenom': 'Nestor', 'ministere': 'Apôtre Patriarche', 'entite': 'Direction Mondiale', 'phone': '+243 812345678'},
    {'nom': 'NGOLO', 'prenom': 'Emmanuel', 'ministere': 'Apôtre de District', 'entite': 'RDC Ouest', 'phone': '+243 822345678'},
    {'nom': 'KIKABA', 'prenom': 'Christian', 'ministere': 'Apôtre', 'entite': 'Champ KSO', 'phone': '+243 833456789'},
    {'nom': 'BUWEKA', 'prenom': 'Théophile', 'ministere': 'Ancien', 'entite': 'District KSO', 'phone': '+243 844567890'},
    {'nom': 'LUSIMBA', 'prenom': 'Caroline', 'ministere': 'Conductrice', 'entite': 'Communauté Kimbangu', 'phone': '+243 823456789'},
    {'nom': 'KILUNGI', 'prenom': 'Christian', 'ministere': 'Berger', 'entite': 'Communauté Libanga', 'phone': '+243 834567890'},
    {'nom': 'NKUNGI', 'prenom': 'Christian', 'ministere': 'Évangéliste', 'entite': 'Centre Ville', 'phone': '+243 845678901'},
    {'nom': 'DIALUNGI', 'prenom': 'Castalac', 'ministere': 'Prêtre', 'entite': 'Communauté Ngaba', 'phone': '+243 856789012'},
    {'nom': 'MBEKU', 'prenom': 'David', 'ministere': 'Diacre', 'entite': 'Communauté Lemba', 'phone': '+243 866789012'},
    {'nom': 'KAPINGA', 'prenom': 'Jean', 'ministere': 'Sous-Diacre', 'entite': 'Communauté Lemba 02', 'phone': '+243 866789013'},
    {'nom': 'MUKENDI', 'prenom': 'Paul', 'ministere': 'Frère Chargé', 'entite': 'Communauté Limete', 'phone': '+243 866789014'},
    {'nom': 'NGOY', 'prenom': 'Marie', 'ministere': 'Lead', 'entite': 'District Centre', 'phone': '+243 866789015'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Corps Ministériel'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSummary(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un ministre ou un ministère...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _ministers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final m = _ministers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF003366).withValues(alpha: 0.1),
                    child: Text(m['nom']![0], style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold)),
                  ),
                  title: Text('${m['prenom']} ${m['nom']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${m['ministere']} • ${m['entite']}', style: const TextStyle(fontSize: 12, color: Color(0xFF003366))),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF003366),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('TOTAL MINISTRES', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('566', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem('Apôtres', '3'),
              _summaryItem('Prêtres', '342'),
              _summaryItem('Diacres', '221'),
            ],
          )
        ],
      ),
    );
  }

  static Widget _summaryItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}
