import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../utils/theme/theme_container.dart';
import '../version_screen.dart';
import 'app_theme/app_theme_screen.dart';
import 'favorite/favorite_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: ThemeContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile/A1.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Adhil Fouzi K",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  title: "Profile",
                  icon: Icons.person,
                  onTap: () {},
                ),
                _buildSettingsOption(
                  title: "App Theme",
                  icon: Icons.dark_mode,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AppThemeScreen()),
                    );
                  },
                  trailing: Switch(
                    activeColor: Colors.amberAccent,
                    value: isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
                _buildSettingsOption(
                  title: "My Recipe",
                  icon: Icons.book,
                  onTap: () {},
                ),
                _buildSettingsOption(
                  title: "Favorite Recipe",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FavoriteScreen()),
                    );
                  },
                ),
                Expanded(child: VersionScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required String title,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
