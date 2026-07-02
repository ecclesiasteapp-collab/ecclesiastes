import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderLine {
  final String label;
  final String value;
  HeaderLine(this.label, this.value);
}

class HeaderOfficiel extends StatelessWidget {
  final String institution;
  final List<HeaderLine>? lines;
  final String typeRapport;
  final DateTime? date;
  final String? codeRapport;
  final List<String> shortCodes;

  // Champs de compatibilité
  final String? champ;
  final String? district;
  final String? communaute;

  const HeaderOfficiel({
    super.key,
    this.institution = 'Eglise Néo – Apostolique',
    this.lines,
    this.typeRapport = "RAPPORT D'ACTIVITÉ",
    this.date,
    this.codeRapport,
    this.shortCodes = const ['SD', 'RF', 'SJ', 'S', 'SE', 'SF', 'MA', 'C'],
    this.champ,
    this.district,
    this.communaute,
  });

  /// Constructeur de compatibilité
  factory HeaderOfficiel.standard({
    required String champ,
    required String district,
    required String communaute,
    String? typeRapport,
    DateTime? date,
    String? codeRapport,
  }) {
    return HeaderOfficiel(
      champ: champ,
      district: district,
      communaute: communaute,
      typeRapport: typeRapport ?? "RAPPORT D'ACTIVITÉ",
      date: date,
      codeRapport: codeRapport,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Construction de la liste des lignes (soit via lines, soit via les champs individuels)
    final List<HeaderLine> displayLines = lines ?? [
      if (champ != null) HeaderLine('CHAMP APOSTOLIQUE', champ!),
      if (district != null) HeaderLine('DISTRICT', district!),
      if (communaute != null) HeaderLine('COMMUNAUTÉ', communaute!),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ...displayLines.map((line) => _buildLine(line.label, line.value)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Image.asset(
                      'assets/branding/logo_ena.png',
                      errorBuilder: (c, e, s) => const Icon(Icons.church, color: Color(0xFF003366)),
                    ),
                  ),
                  if (codeRapport != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        codeRapport!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 1.5)),
            ),
            child: Text(
              typeRapport.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.1),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Type: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: shortCodes.map((t) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildSmallBox(t),
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('Date : ${date != null ? DateFormat('dd/MM/yyyy').format(date!) : "..../..../20...."}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text('$label :', style: const TextStyle(fontSize: 11, color: Colors.blueGrey))),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
              ),
              child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

