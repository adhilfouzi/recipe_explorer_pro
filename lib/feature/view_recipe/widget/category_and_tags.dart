import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryAndTags extends StatelessWidget {
  final String category;
  final String tags;

  const CategoryAndTags(
      {super.key, required this.category, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          _buildTag("Category: $category"),
          const SizedBox(width: 10),
          _buildTag("Tags: $tags"),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(fontSize: 14, color: Colors.brown.shade800),
      ),
    );
  }
}
