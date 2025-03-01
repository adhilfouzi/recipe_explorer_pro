import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeButtons extends StatelessWidget {
  final String? sourceUrl;
  final String? youtubeUrl;

  const RecipeButtons({super.key, this.sourceUrl, this.youtubeUrl});

  @override
  Widget build(BuildContext context) {
    if (sourceUrl != null && sourceUrl!.isNotEmpty ||
        youtubeUrl != null && youtubeUrl!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (sourceUrl != null && sourceUrl!.isNotEmpty)
              Expanded(
                child: _buildButton(
                  onTap: () => _launchURL(sourceUrl!),
                  icon: Icons.link,
                  text: "Source",
                  colors: [Colors.brown.shade700, Colors.brown.shade400],
                ),
              ),
            if (youtubeUrl != null && youtubeUrl!.isNotEmpty)
              Expanded(
                child: _buildButton(
                  onTap: () => _launchURL(youtubeUrl!),
                  icon: Icons.play_circle_fill,
                  text: "Watch Video",
                  colors: [Colors.red.shade700, Colors.red.shade400],
                ),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  // Gradient Button Widget
  Widget _buildButton({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: colors.first.withAlpha((0.4 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Open URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }
}
