import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchbar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed; // Callback pour l'icône de filtrage
  const Searchbar({super.key, this.onChanged, this.onFilterPressed});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45, // Hauteur ajustée
        width: MediaQuery.of(context).size.width * 0.9, // Largeur ajustée (90% de l'écran)
        decoration: BoxDecoration(
          color: Colors.white, // Fond blanc
          borderRadius: BorderRadius.circular(20), // Coins arrondis
          border: Border.all(color: Colors.green, width: 2), // Bordure verte
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Ombre douce
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icône de recherche à droite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.search, color: Colors.green, size: 24),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: 'ابحث هنا...',
                  hintStyle: GoogleFonts.cairo(color: Colors.grey),
                  border: InputBorder.none, // Suppression des bordures internes
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(color: Colors.black),
              ),
            ),
            // Icône de filtrage à gauche
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.green),
              onPressed: widget.onFilterPressed, // Action pour le filtrage
            ),
          ],
        ),
      ),
    );
  }
}