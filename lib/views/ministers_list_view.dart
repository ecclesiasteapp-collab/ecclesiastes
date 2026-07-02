import 'package:flutter/material.dart';
import 'package:ecclesiastes/core/theme.dart';

class MinistersListView extends StatefulWidget {
  final String? entiteId;
  final String? entiteNom;
  const MinistersListView({super.key, this.entiteId, this.entiteNom});

  @override
  State<MinistersListView> createState() => _MinistersListViewState();
}

class _MinistersListViewState extends State<MinistersListView> {
  // Simulant une liste de ministres pour l'exemple
  final List<Map<String, String>> _allMinisters = [
    {'nom': 'MBUYI', 'prenom': 'Nestor', 'ministere': 'Prêtre', 'entite': 'Libanga', 'phone': '+243 812345678'},
    {'nom': 'LUSIMBA', 'prenom': 'Caroline', 'ministere': 'Conductrice', 'entite': 'Kimbangu', 'phone': '+243 823456789'},
    {'nom': 'KILUNGI', 'prenom': 'Christian', 'ministere': 'Berger', 'entite': 'District Nord', 'phone': '+243 834567890'},
    {'nom': 'NKUNGI', 'prenom': 'Christian', 'ministere': 'Évangéliste', 'entite': 'Centre Ville', 'phone': '+243 845678901'},
    {'nom': 'DIALUNGI', 'prenom': 'Castalac', 'ministere': 'Ancien', 'entite': 'District KSO', 'phone': '+243 856789012'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Annuaire des Ministres'),
            if (widget.entiteNom != null)
              Text(widget.entiteNom!.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSummaryHeader(),
          _buildFilterBar(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _allMinisters.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final m = _allMinisters[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Hero(
                    tag: 'minister_${m['nom']}',
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      child: Text(m['prenom']![0], style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  title: Text('${m['prenom']} ${m['nom']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['ministere']!, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('Entité: ${m['entite']}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.chevron_right, color: AppTheme.primary),
                  ),
                  onTap: () => _showMinisterDetails(m),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un ministre...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', _allMinisters.length.toString(), Colors.white),
          _buildStatItem('Prêtres', '12', Colors.white70),
          _buildStatItem('Diacres', '8', Colors.white70),
          _buildStatItem('Conductrices', '5', Colors.white70),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, Color textColor) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        Text(label, style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.8))),
      ],
    );
  }

  void _showMinisterDetails(Map<String, String> m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(radius: 35, backgroundColor: AppTheme.primary, child: Text(m['prenom']![0], style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${m['prenom']} ${m['nom']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      Text(m['ministere']!, style: const TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _detailCard(Icons.location_city, 'Affectation', m['entite']!),
            _detailCard(Icons.phone_android, 'Contact direct', m['phone']!),
            _detailCard(Icons.alternate_email, 'Email professionnel', '${m['nom']!.toLowerCase()}.${m['prenom']!.toLowerCase()}@ena-rdco.org'),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('SMS'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    label: const Text('Appeler'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppTheme.primary, size: 20)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}

