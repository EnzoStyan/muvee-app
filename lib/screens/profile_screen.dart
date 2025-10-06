// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/profile_update_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profil
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.accentYellow,
                    child: Icon(Icons.person, size: 50, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.displayName ?? user?.email ?? 'Pengguna Muvee',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Opsi Pengaturan
            _buildSettingOption(context, 'Account Settings', Icons.settings, () {
              // ⭐️ TAMPILKAN DIALOG UPDATE PROFILE ⭐️
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return ProfileUpdateDialog(user: user!); // user! karena kita tahu user tidak null di sini
                },
              );
            }),
            _buildSettingOption(context, 'App Preferences', Icons.tune, () {}),
            _buildSettingOption(context, 'Help & Support', Icons.help_outline, () {}),

            const Divider(color: AppColors.bgGray, height: 40),

            // Tombol Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () async {
                await authService.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textLight),
      title: Text(title, style: const TextStyle(color: AppColors.textWhite)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}