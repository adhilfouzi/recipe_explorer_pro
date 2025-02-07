import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/category_model.dart';
import '../../../utils/constants/shimmer.dart';

class CategoriesHead extends StatelessWidget {
  final CategoryModel category;
  const CategoriesHead({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: category.image,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30)),
            child: CachedNetworkImage(
              imageUrl: category.image,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                child: ShimmerPlaceholder(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.8), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                category.name,
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
