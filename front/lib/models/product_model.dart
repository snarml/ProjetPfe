class Product {
  final String id;
  final String nom;
  final String description;
  final double prix;
  final double quantite;
  final String image;
  final int categoryId;
  final String? category;
  final bool disponible;
  final String? offerType; 
  final String createdAt;
  final String updatedAt;
  bool checked;

  Product({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.quantite,
    required this.image,
    required this.categoryId,
     this.category,
    required this.disponible,
    this.offerType,
    required this.createdAt,
    required this.updatedAt,
    this.checked = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    String processImagePath(dynamic imageValue) {
      if (imageValue == null) return '';
      
      // Si c'est une URL Drive ou une URL complète, retourne-la telle quelle
      if (imageValue.toString().contains('drive.google.com') ||
          imageValue.toString().startsWith('http')) {
        return imageValue.toString();
      }
      
      // Si c'est un nom de fichier du backend, retourne-le tel quel
      return imageValue.toString();
    }

    return Product(
      id: map['id'].toString(),
      nom: map['nom'] ?? '',
      description: map['description'] ?? '',
      prix: double.tryParse(map['prix'].toString()) ?? 0.0,
      quantite: double.tryParse(map['quantite'].toString()) ?? 0.0,
      image: processImagePath(map['image_url'] ?? map['image']), // Gère les deux noms possibles
      categoryId: map['categorie_id'] ?? 0,
      category: map['category'] != null ? map['category']['nom'] : null,
      disponible: map['disponible'] == 1 || map['disponible'] == true,
      offerType: map['type_offre'],
      createdAt: map['createdAt'] ?? 'غير محدد',
      updatedAt: map['updatedAt'] ?? 'غير محدد',
      checked: map['checked'] ?? false,
    );
  }

  // Méthode pour convertir en Map (utile pour les requêtes API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
      'quantite': quantite,
      'image': image,
      'categorie_id': categoryId, // Corrigé le nom du champ
      'category': category,
      'disponible': disponible,
      'type_offre': offerType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'checked': checked,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  Product copyWith({
    String? id,
    String? nom,
    String? description,
    double? prix,
    double? quantite,
    String? image,
    int? categoryId,
    String? category,
    bool? disponible,
    String? offerType,
    String? createdAt,
    String? updatedAt,
    bool? checked,
  }) {
    return Product(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      prix: prix ?? this.prix,
      quantite: quantite ?? this.quantite,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      disponible: disponible ?? this.disponible,
      offerType: offerType ?? this.offerType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checked: checked ?? this.checked,
    );
  }
}