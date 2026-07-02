// lib/screens/navigation/district_selector_screen.dart
import 'package:flutter/material.dart';
import '../../config/kso_districts_data.dart';

class DistrictSelectorScreen extends StatefulWidget {
  const DistrictSelectorScreen({super.key});

  @override
  State<DistrictSelectorScreen> createState() => _DistrictSelectorScreenState();
}

class _DistrictSelectorScreenState extends State<DistrictSelectorScreen> {
  String _searchQuery = '';

  List<KsoDistrict> get _filteredDistricts {
    if (_searchQuery.isEmpty) return KsoChampData.districts;
    return KsoChampData.districts
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        title: const Text('Sélectionner un District'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Rechercher un district (ex: Malueka, Binza...)',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          
          // Liste filtrée
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredDistricts.length,
              itemBuilder: (context, index) {
                final district = _filteredDistricts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: const Color(0xFF003366), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text('${district.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                    title: Text('District de ${district.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          _buildChip('${district.communitiesCount} Ctés', Colors.blue.shade50, Colors.blue.shade900),
                          const SizedBox(width: 8),
                          _buildChip('${district.membersCount} Membres', Colors.green.shade50, Colors.green.shade900),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      // Action : Ouvrir les communautés de ce district
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ouverture des communautés du district de ${district.name}...')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

