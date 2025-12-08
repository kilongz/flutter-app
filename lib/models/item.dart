class Item {
  final int id;
  final String itemName;
  final String brand;
  final String status;
  final String category;

  Item({
    required this.id,
    required this.itemName,
    required this.brand,
    required this.status,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemName: json['item_name'],
      brand: json['brand'],
      status: json['status'],
      category: json['category']['category_name'],
    );
  }
}
