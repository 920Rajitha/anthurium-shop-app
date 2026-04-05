class Plant {
  final String id;
  final String name;
  final String category;
  final String description;
  final String image;
  final int stock;
  final Map<String, String> prices;

  Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.stock,
    required this.prices,
  });

  factory Plant.fromFirestore(Map<String, dynamic> data, String id) {
    return Plant(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      stock: data['stock'] ?? 0,
      prices: Map<String, String>.from(data['prices'] ?? {}),
    );
  }
}