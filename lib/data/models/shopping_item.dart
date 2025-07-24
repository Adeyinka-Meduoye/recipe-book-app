class ShoppingItem {
  final String name;
  final double quantity;
  final String unit; // e.g., "g", "ml", "unit"
  final bool isChecked;

  ShoppingItem({
    required this.name,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'isChecked': isChecked,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        name: json['name'],
        quantity: json['quantity'],
        unit: json['unit'],
        isChecked: json['isChecked'],
      );
}