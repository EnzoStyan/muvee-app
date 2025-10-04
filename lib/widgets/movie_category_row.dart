import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../core/api_constants.dart';

class MovieCategoryRow extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;

  const MovieCategoryRow({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Kategori
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        // Barisan Scroll Horizontal
        SizedBox(
          height: 200, // Tinggi yang cukup untuk poster
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: _buildPoster(context, movie),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoster(BuildContext context, MovieModel movie) {
    // Pastikan posterPath ada
    final posterUrl = movie.posterPath != null
        ? '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        // TODO: Implementasi Navigasi ke Halaman Detail Film
        debugPrint('Tapped on ${movie.title}');
      },
      child: Container(
        width: 130, // Lebar Poster
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).colorScheme.surface, // Background Gray dari theme
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: posterUrl != null
              ? Image.network(
            posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          )
              : const Center(child: Text('No Poster')),
        ),
      ),
    );
  }
}