import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants/images.dart';
import '../utils/theme/theme_container.dart';
import '../version_screen.dart';
import 'app_theme/app_theme_screen.dart';
import 'favorite/favorite_screen.dart';
import 'my_recipe/my_recipe_screen.dart';
import 'profile/profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final user = Provider.of<UserProvider>(context).user;

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
                  radius: 60,
                  backgroundImage: user.profile.isEmpty
                      ? AssetImage(Images.avatar)
                      : AssetImage(user.profile),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                SettingsOption(
                  title: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                SettingsOption(
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
                SettingsOption(
                  title: "My Recipe",
                  icon: Icons.book,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyRecipeScreen()),
                    );
                  },
                ),
                SettingsOption(
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
}

class SettingsOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsOption({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
