import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/category_model.dart';
import '../../categories/categories_screen.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoriesScreen(category: category)));
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  Image.network(category.image, height: 60, fit: BoxFit.fill),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style:
                  GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
