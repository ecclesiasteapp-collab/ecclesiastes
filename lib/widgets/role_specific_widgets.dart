import 'package:flutter/material.dart';

/// Widgets spécifiques aux différents rôles
class ResponsibleCard extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onTap;

  const ResponsibleCard({
    super.key,
    required this.name,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class FinancialStatsCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const FinancialStatsCard({
    super.key,
    required this.label,
    required this.amount,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class EntityTile extends StatelessWidget {
  final String name;
  final String type;
  final VoidCallback? onTap;

  const EntityTile({
    super.key,
    required this.name,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(name),
      subtitle: Text(type),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class ReportSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ReportSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

