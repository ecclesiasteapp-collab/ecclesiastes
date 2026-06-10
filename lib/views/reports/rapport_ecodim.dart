import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ecclesiastes/widgets/header_officiel.dart';
import 'package:ecclesiastes/widgets/kpi_card.dart';
import 'package:ecclesiastes/widgets/validation_panel.dart';
import 'package:ecclesiastes/widgets/recommendations_panel.dart';
import 'package:ecclesiastes/models/report.dart';

class RapportEcodimScreen extends StatefulWidget {
  const RapportEcodimScreen({super.key});

  @override
  State<RapportEcodimScreen> createState() => _RapportEcodimScreenState();
}

class _RapportEcodimScreenState extends State<RapportEcodimScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCommunityValidated = false;

  final List<KPI> _kpis = [
    KPI(nom: 'Présence moyenne', valeur: 78, objectif: 85, unite: '%', periode: DateTime.now()),
    KPI(nom: 'Cahiers distribués', valeur: 42, objectif: 45, unite: '', periode: DateTime.now()),
  ];

  final List<String> _recos = [
    'Utiliser le cahier "Moi aussi..." pour chaque élève',
    'Préparer la leçon 48h avant le cours',
    'Respecter la méthode dialogique (pas de lecture directe)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Rapport École du Dimanche'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderOfficiel(
              champ: 'Champ d\'Apôtre de Kinshasa Sud-Ouest',
              district: 'District de Ngaliema',
              communaute: 'Communauté Centrale',
              typeRapport: 'RAPPORT ECOLE DU DIMANCHE (ECODIM)',
              date: DateTime.now(),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: KPICard(kpi: _kpis[0])),
                Expanded(child: KPICard(kpi: _kpis[1])),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊 DONNÉES PÉDAGOGIQUES', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'lecon_n',
                      decoration: const InputDecoration(labelText: 'Leçon traitée (N° et Titre)', border: OutlineInputBorder()),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'presents',
                            decoration: const InputDecoration(labelText: 'Enfants présents', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'moniteurs',
                            decoration: const InputDecoration(labelText: 'Moniteurs actifs', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            RecommendationsPanel(items: _recos),
            const SizedBox(height: 16),

            DoubleValidationPanel(
              isCommunityValidated: _isCommunityValidated,
              onValidateCommunity: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  setState(() => _isCommunityValidated = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Validé par le Responsable Communauté')));
                }
              },
              onValidateHierarchical: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🚀 Transmis pour validation hiérarchique')));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
