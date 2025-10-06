// lib/widgets/profile_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class ProfileUpdateDialog extends StatefulWidget {
  final User user;

  const ProfileUpdateDialog({super.key, required this.user});

  @override
  State<ProfileUpdateDialog> createState() => _ProfileUpdateDialogState();
}

class _ProfileUpdateDialogState extends State<ProfileUpdateDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Isi field dengan nama display saat ini
    _nameController.text = widget.user.displayName ?? '';
  }

  Future<void> _handleUpdate() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      setState(() => _error = 'Nama tidak boleh kosong.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.updateDisplayName(newName);

      // Sukses: Tutup dialog
      if (mounted) Navigator.of(context).pop();

    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgGray,
      title: const Text('Update Profile', style: TextStyle(color: AppColors.textWhite)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: InputDecoration(
              labelText: 'Nama Tampilan',
              labelStyle: const TextStyle(color: AppColors.textLight),
              errorText: _error,
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: CircularProgressIndicator(color: AppColors.accentYellow),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(color: AppColors.textLight)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleUpdate,
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}