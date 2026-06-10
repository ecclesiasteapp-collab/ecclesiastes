import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderOfficiel extends StatelessWidget {
  final String champ;
  final String district;
  final String communaute;
  final String typeRapport;
  final DateTime? date;

  const HeaderOfficiel({
    super.key,
    required this.champ,
    required this.district,
    required this.communaute,
    this.typeRapport = "RAPPORT DE SERVICE DIVIN",
    this.date,
  });

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      'Eglise Néo – Apostolique de la RDC – Ouest',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildLine('CHAMP APOSTOLIQUE', champ),
                    _buildLine('DISTRICT', district),
                    _buildLine('COMMUNAUTÉ', communaute),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade900),
                ),
                child: Image.asset(
                  'assets/images/logo_ena.png',
                  errorBuilder: (c, e, s) => const Icon(Icons.church, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 2)),
            ),
            child: Text(
              typeRapport.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Jour : ', style: TextStyle(fontSize: 12)),
              _buildSmallBox('DM'),
              const SizedBox(width: 4),
              _buildSmallBox('JDS'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Type: ', style: TextStyle(fontSize: 12)),
              ...['SD', 'RF', 'SJ', 'S', 'SE', 'SF', 'MA', 'C'].map((t) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _buildSmallBox(t),
              )),
              const Spacer(),
              Text('Date : Le ${date != null ? DateFormat('dd/MM/yyyy').format(date!) : "..../..../20...."}', 
                style: const TextStyle(fontSize: 12)),
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
          SizedBox(width: 130, child: Text('$label :', style: const TextStyle(fontSize: 12))),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
              ),
              child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
