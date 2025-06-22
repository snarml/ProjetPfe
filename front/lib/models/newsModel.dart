class News {
  final int id;
  final String titre;
  final String description;
  final String? imageUrl;
  final String auteur;
  final DateTime datePublication;

  News({
    required this.id,
    required this.titre,
    required this.description,
    this.imageUrl,
    required this.auteur,
    required this.datePublication,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      auteur: json['creator']['full_name'] as String, // dépend du include dans findAll
      datePublication: DateTime.parse(json['created_at'] as String),
    );
  }
}
