enum InventoryCategory { building, instrument, furniture, liturgical, other }

class InventoryItem {
  final String id;
  final String name;
  final InventoryCategory category;
  final String entityId;
  final double? value;
  final DateTime acquisitionDate;
  final String? condition;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.entityId,
    this.value,
    required this.acquisitionDate,
    this.condition,
  });
}
