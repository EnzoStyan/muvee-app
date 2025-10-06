// lib/screens/my_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/api_constants.dart';
import '../providers/my_list_provider.dart';
import '../models/movie_model.dart';
import '../theme/app_colors.dart';
import 'movie_detail_screen.dart'; // Untuk navigasi detail film

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mendengarkan MyListProvider
    return Consumer<MyListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentYellow),
            ),
          );
        }

        if (provider.myList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Daftar Saya masih kosong.\nTambahkan film favoritmu dari Home Screen!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Tampilkan Grid View untuk daftar film
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Tiga kolom seperti di Netflix
              childAspectRatio: 0.65, // Rasio Poster
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.myList.length,
            itemBuilder: (context, index) {
              final movie = provider.myList[index];
              return _buildMovieGridItem(context, movie);
            },
          ),
        );
      },
    );
  }

  Widget _buildMovieGridItem(BuildContext context, MovieModel movie) {
    final posterUrl = movie.posterPath != null
        ? '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        // Navigasi ke Halaman Detail Film saat poster diklik
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: AppColors.bgGray,
          child: posterUrl != null
              ? Image.network(
            posterUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(color: AppColors.accentYellow));
            },
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.textLight),
          )
              : Center(
            child: Text(movie.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}