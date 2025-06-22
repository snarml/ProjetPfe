import 'dart:io';

import 'package:bitakati_app/models/product_model.dart';
import 'package:bitakati_app/screens/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductItem extends StatefulWidget {
  final String id;
  final String nom;
  final String prix;
  final String imagePath;
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Product product;

  const ProductItem({
    super.key,
    required this.id,
    required this.nom,
    required this.prix,
    required this.imagePath,
    required this.isChecked,
    required this.onChanged,
    required this.product,
  });

  // URL de base pour accéder aux images sur le backend
  static const String backendUrl = 'http://10.0.2.2:4000/uploads/';   
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _navigateToDetails(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Utilise un Stack pour superposer le cœur sur l'image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: _buildImage(widget.product.image ?? widget.imagePath), // Utilise l'image du modèle Product directement
                  ),
                  // Icône cœur en haut à droite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        // Ajoute ici la logique pour sauvegarder le favori si besoin
                      },
                      tooltip: 'Ajouter aux favoris',
                      splashRadius: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Text(
                    widget.nom, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${widget.prix} دينار ', 
                    style: const TextStyle(color: Color.fromARGB(255, 102, 100, 100))
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        value: widget.isChecked,
                        onChanged: widget.onChanged,
                        activeColor: Colors.green,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: _navigateToDetails,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cette méthode construit l'URL complète de l'image si nécessaire
  String _getCompleteImageUrl(String? imagePath) {
    // Pour debug
    print('_getCompleteImageUrl - chemin reçu: $imagePath');
    
    // Si le chemin est null ou vide
    if (imagePath == null || imagePath.isEmpty) {
      print('Chemin vide ou null, utilisation placeholder');
      return 'https://via.placeholder.com/150';
    }
    
    // Si c'est une URL Drive
    if (imagePath.contains('drive.google.com')) {
      print('URL Drive détectée: $imagePath');
      return imagePath;
    }
    
    // Si c'est déjà une URL complète
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      print('URL complète détectée: $imagePath');
      return imagePath;
    }
    
    // Si c'est un chemin de fichier local (commence par /)
    if (imagePath.startsWith('/')) {
      print('Chemin local détecté: $imagePath');
      return imagePath;
    }
    
    // Si c'est un nom de fichier du backend
    final url = '${ProductItem.backendUrl}$imagePath';
    print('URL backend générée: $url');
    return url;
  }

  Widget _buildImage(String? imagePath) {
    print('_buildImage - chemin initial: $imagePath');
    
    // Vérifie si le chemin est valide
    if (imagePath?.trim().isEmpty ?? true) {
      print('Chemin d\'image invalide ou vide');
      return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }

    final completeUrl = _getCompleteImageUrl(imagePath);
    print('URL finale à utiliser: $completeUrl');

    // Si c'est une URL (incluant Drive)
    if (completeUrl.startsWith('http')) {
      return Image.network(
        completeUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
              color: Colors.green,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Erreur chargement image ($completeUrl): $error');
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    }

    // Si c'est un fichier local
    return Image.file(
      File(completeUrl),
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        print('Erreur fichier local ($completeUrl): $error');
        return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
      },
    );
  }

  void _navigateToDetails() {
    Get.to(
      () => ProductDetailsPage(
        productId: widget.id,
        productName: widget.nom,
        productPrice: widget.prix,
        productImage: _getCompleteImageUrl(widget.product.image ?? widget.imagePath), // Utilise l'image du modèle Product
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}