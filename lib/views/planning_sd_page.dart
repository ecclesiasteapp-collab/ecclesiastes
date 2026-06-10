import 'package:flutter/material.dart';
// Pour utiliser le modèle existant

class PlanningSDPage extends StatefulWidget {
  const PlanningSDPage({super.key});

  @override
  State<PlanningSDPage> createState() => _PlanningSDPageState();
}

class _PlanningSDPageState extends State<PlanningSDPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Planification des Services")),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2025),
            lastDate: DateTime(2030),
            onDateChanged: (d) => setState(() => _selectedDate = d),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPlanningCard("Matin (DM)", "Prêtre Christian Kikaba"),
                _buildPlanningCard("Semaine (JDS)", "Diacre Nestor Mbuyi"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanningCard(String period, String officiant) {
    return Card(
      child: ListTile(
        title: Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Officiant: $officiant"),
        trailing: const Icon(Icons.edit),
      ),
    );
  }
}
