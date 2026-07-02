import 'package:flutter/material.dart';

class CommissionCardData {
  final String title;
  final String section; // e.g. "Administration & Support"
  final double progress;
  final String status; // e.g. "À jour", "En attente", "Pas de responsable"

  CommissionCardData({
    required this.title,
    required this.section,
    required this.progress,
    required this.status,
  });
}

class CommissionGrid extends StatelessWidget {
  final List<CommissionCardData> commissions;
  final Function(CommissionCardData) onTap;

  const CommissionGrid({
    super.key,
    required this.commissions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (width > 600) crossAxisCount = 2;
    if (width > 900) crossAxisCount = 3;
    if (width > 1200) crossAxisCount = 4;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Suivi des 12 Commissions Locally',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Assigner un Responsable'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 110,
          ),
          itemCount: commissions.length,
          itemBuilder: (context, index) {
            final comm = commissions[index];
            return _buildCard(context, comm);
          },
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, CommissionCardData comm) {
    Color statusColor = Colors.green;
    if (comm.status == 'En attente') statusColor = Colors.orange;
    if (comm.status == 'Pas de responsable') statusColor = Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onTap(comm),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    comm.section,
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.bookmark_outline, size: 14, color: Color(0xFF003366)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comm.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: comm.progress,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF003366),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  comm.status,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

