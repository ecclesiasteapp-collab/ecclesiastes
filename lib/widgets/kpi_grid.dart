import 'package:flutter/material.dart';
import '../models/report_config.dart';
import 'kpi_card.dart';
import '../models/report.dart';

class KPIGrid extends StatelessWidget {
  final List<KPIConfig> configs;
  
  const KPIGrid({super.key, required this.configs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: configs.map((k) => 
        SizedBox(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          child: KPICard(kpi: KPI(
            nom: k.label, 
            valeur: 0, // Valeur par défaut avant saisie
            objectif: k.target, 
            unite: k.unit, 
            periode: DateTime.now()
          )),
        )
      ).toList(),
    );
  }
}
