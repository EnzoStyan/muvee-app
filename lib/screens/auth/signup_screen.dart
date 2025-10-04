// lib/screens/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_passwordController.text.length < 6) {
        throw Exception("Password minimal harus 6 karakter.");
      }

      final authService = Provider.of<AuthService>(context, listen: false);
      // Panggil metode signUp dari AuthService
      await authService.signUp(_emailController.text.trim(), _passwordController.text.trim());

      // Jika registrasi berhasil, AuthWrapper akan otomatis mengarahkan ke MainWrapper (Home)
    } catch (e) {
      setState(() {
        // Penanganan error Firebase yang lebih spesifik
        if (e.toString().contains('email-already-in-use')) {
          _errorMessage = 'Email ini sudah terdaftar. Coba login atau gunakan email lain.';
        } else if (e.toString().contains('invalid-email')) {
          _errorMessage = 'Format email tidak valid.';
        } else {
          _errorMessage = 'Registrasi gagal: ${e.toString().split(':')[1].trim()}';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar ke Muvee')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Judul
              Text(
                'Buat Akun Muvee Baru',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentYellow,
                ),
              ),
              const SizedBox(height: 40),

              // Input Email
              _buildInputField(_emailController, 'Email', Icons.email),
              const SizedBox(height: 20),

              // Input Password
              _buildInputField(_passwordController, 'Password (Min. 6 Karakter)', Icons.lock, isPassword: true),
              const SizedBox(height: 30),

              // Tampilkan Error Message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.primaryDark)
                      : const Text('DAFTAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Kembali ke Login
              TextButton(
                onPressed: () {
                  // Kembali ke halaman Login (Pop current screen)
                  Navigator.of(context).pop();
                },
                child: const Text('Sudah punya akun? Masuk di sini', style: TextStyle(color: AppColors.textLight)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.textWhite),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight),
        prefixIcon: Icon(icon, color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.bgGray.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}