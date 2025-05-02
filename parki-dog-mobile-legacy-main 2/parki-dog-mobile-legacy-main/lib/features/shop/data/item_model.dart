class ItemDetails {
  final String name;
  int? quantity = 0;
  final int id;
  final List<String> imagePath;
  final num? rate;
  final String? description;
  final num? reviewsNumber;
  final num price;
  final num? price2;
  final String? category;
  final String? viewLink;
  ItemDetails({
    this.viewLink,
    this.price2,
    this.category,
    required this.price,
    required this.name,
    this.quantity,
    required this.id,
    required this.imagePath,
    this.rate,
    this.description,
    this.reviewsNumber,
  });
  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      name: json['name'],
      quantity: json['quantity'] ?? 0,
      id: json['id'],
      imagePath: List<String>.from(json['imagePath']),
      rate: json['rate'],
      description: json['description'],
      reviewsNumber: json['reviewsNumber'],
      price: json['price'],
      price2: json['price2'],
      category: json['category'],
      viewLink: json['viewLink'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'id': id,
      'imagePath': imagePath,
      'rate': rate,
      'description': description,
      'reviewsNumber': reviewsNumber,
      'price': price,
      'price2': price2,
      'category': category,
      'vewLink': viewLink,
    };
  }
}
