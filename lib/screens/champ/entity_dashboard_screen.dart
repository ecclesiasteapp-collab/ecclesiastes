// lib/screens/champ/kso_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/utils/entite_types.dart';


class EntityDashboardScreen extends StatelessWidget {
  final String entityId;
  const EntityDashboardScreen({super.key, required this.entityId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>( 
      future: DatabaseHelper.instance.getEntiteById(entityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('Erreur de chargement de l\'entité ou entité non trouvée.')));
        }
        final entity = snapshot.data!;
        final entityName = entity['nom'] ?? 'Inconnu';
        final entityType = entity['type'] ?? 'Inconnu';
        final responsableNom = entity['responsable_nom'] ?? 'À désigner';
        final nombreDistricts = entity['nombre_districts'] ?? 0;
        final nombreCommunautes = entity['nombre_communautes'] ?? 0;
        final nombreMembres = entity['nombre_membres'] ?? 0;
        final nombreMinistres = entity['nombre_ministres'] ?? 0;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: const Color(0xFF003366),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entityName, style: const TextStyle(fontSize: 16)),
                Text(EntiteTypes.label(entityType.toString()), style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête Responsable
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF003366), Color(0xFF005B9F)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Responsable de l\'${EntiteTypes.label(entityType.toString()).toLowerCase()}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(responsableNom,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Date synoptique peut être ajoutée dynamiquement si disponible dans le modèle d'entité
                      // Text("Tableau synoptique du ${entity["date_synoptique"] ?? "N/A"}",
                      //     style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Cartes KPI
                const Text('STATISTIQUES GLOBALES',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                Expanded(
                    child: _buildKpiCard(
                        '${EntiteTypes.label(EntiteTypes.district)}s',
                        '$nombreDistricts',
                        Icons.map,
                        Colors.blue)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildKpiCard(
                        '${EntiteTypes.label(EntiteTypes.communaute)}s',
                        '$nombreCommunautes',
                        Icons.church,
                        Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                Expanded(
                    child: _buildKpiCard(
                        'Membres',
                        '$nombreMembres',
                        Icons.people,
                        Colors.orange)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildKpiCard(
                        'Ministres',
                        '$nombreMinistres',
                        Icons.badge,
                        Colors.purple)),
                  ],
                ),
                const SizedBox(height: 24),

                // Liste des sous-entités (Districts, Champs, etc.)
                FutureBuilder<List<Map<String, dynamic>>>( 
                  future: () {
                    final nextType = EntiteTypes.enfantDe(entityType.toString());
                    if (nextType == null) return Future.value(<Map<String, dynamic>>[]);
                    return DatabaseHelper.instance.getSubEntites(entityId, nextType);
                  }(),
                  builder: (context, subEntitiesSnapshot) {
                    if (subEntitiesSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (subEntitiesSnapshot.hasError || !subEntitiesSnapshot.hasData || subEntitiesSnapshot.data!.isEmpty) {
                      return const SizedBox.shrink(); // Pas de sous-entités ou erreur
                    }
                    final subEntities = subEntitiesSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${EntiteTypes.label(EntiteTypes.enfantDe(entityType.toString()) ?? '')}s'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subEntities.length,
                          itemBuilder: (context, index) {
                            final subEntity = subEntities[index];
                            final subEntityName = subEntity['nom'] ?? 'Inconnu';
                            final subEntityType = subEntity['type'] ?? 'Inconnu';
                            
                            // Afficher des détails pertinents selon le type de sous-entité
                            var subtitleText = '';
                            if (subEntityType == EntiteTypes.district) {
                              subtitleText = '${subEntity['nombre_communautes'] ?? 0} communautés • ${subEntity['nombre_membres'] ?? 0} membres';
                            } else if (subEntityType == EntiteTypes.champApostolique) {
                              subtitleText = '${subEntity['nombre_districts'] ?? 0} districts • ${subEntity['nombre_communautes'] ?? 0} communautés';
                            }

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF003366),
                                  child: Text(subEntity['code'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                title: Text(subEntityName,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(subtitleText),
                                trailing:
                                    const Icon(Icons.chevron_right, color: Colors.grey),
                                onTap: () {
                                  // Naviguer vers le détail de la sous-entité
                                  // Exemple: GoRouter.of(context).push('/dashboard/${subEntity['id']}');
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

