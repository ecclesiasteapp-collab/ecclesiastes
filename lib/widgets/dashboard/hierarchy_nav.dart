import 'package:flutter/material.dart';

class HierarchyNav extends StatelessWidget {
  final List<String> levels;
  final int activeIndex;
  final Function(int) onLevelTap;

  const HierarchyNav({
    super.key,
    required this.levels,
    required this.activeIndex,
    required this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: levels.length,
        separatorBuilder: (context, index) => const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return GestureDetector(
            onTap: () => onLevelTap(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0066CC) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isActive ? const Color(0xFF0066CC) : Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  levels[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black87,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
