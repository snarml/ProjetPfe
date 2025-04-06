import 'package:flutter/material.dart';

class BuildPostCard extends StatelessWidget {
  final Icon profileImage;
  final String username;
  final String date;
  final String category;
  final String quality;
  final List<String> images;
  const BuildPostCard({
    super.key,
    required this.profileImage,
    required this.username,
    required this.date,
    required this.category,
    required this.quality,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Arrière-plan blanc explicite
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                // Bouton "إقرأ المزيد" à gauche
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "إقرأ المزيد",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(), // Pousse les éléments suivants vers la droite
                // Information utilisateur à droite
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 64, 63, 63),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width:10),
                      CircleAvatar(
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height:10),
            // Description du produit alignée à droite
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    quality,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 47, 45, 45),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // Images améliorées - affichage plus grand et mieux espacé
            SizedBox(
              height: 120, // Hauteur augmentée
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    width: 100, 
                    margin: const EdgeInsets.only(right: 15), // Espacement amélioré
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            // Boutons d'interaction 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    Text("12"),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text("4"),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    Text("4"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}