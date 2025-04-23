

class Product {
  final String id;
  final String nom;
  final String prix;
  final String image;
  final String category;
  bool checked;

  Product({
    required this.id,
    required this.nom,
    required this.prix,
    required this.image,
    required this.category,
    this.checked = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nom: map['nom'],
      prix: map['prix'],
      image: map['image'],
      category: map['category'],
      checked: map['checked'] ?? false,
    );
  }
}