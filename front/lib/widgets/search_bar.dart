import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchbar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;
  
  const Searchbar({
    super.key, 
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icône de filtrage à gauche
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.green),
              onPressed: widget.onFilterPressed,
              tooltip: 'فلترة المنتجات',
            ),
            // Champ de recherche
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  // Appeler onSearchChanged avec la nouvelle valeur
                  widget.onSearchChanged(value);
                  print('🔍 Recherche: $value'); // Debug
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج...',
                  hintStyle: GoogleFonts.cairo(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  // Bouton pour effacer le texte
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _controller.clear();
                            widget.onSearchChanged('');
                          },
                        )
                      : null,
                ),
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(color: Colors.black),
              ),
            ),
            // Icône de recherche à droite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.search, color: Colors.green, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}