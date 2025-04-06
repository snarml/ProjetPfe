import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barre de recherche
        SizedBox(
          width: 310,
          height: 60,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 252, 252),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 121, 116, 116),
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: 'ابحث',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.green),
                    onPressed: () {
                      // Action de recherche
                    },
                  ),
                ],
              ),
            ),
          ),
        
        const SizedBox(width: 4), // Espace entre la barre et l'icône de filtre
        // Bouton filtre (extérieur)
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 121, 116, 116),
                blurRadius: 3,
                offset: Offset(0,2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: Colors.white,size: 26),
            onPressed: () {
              // Action pour les filtres
            },
          ),
        ),
      ],
    );
  }
}
