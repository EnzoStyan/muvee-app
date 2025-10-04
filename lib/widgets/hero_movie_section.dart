// lib/widgets/hero_movie_section.dart

import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../core/api_constants.dart';
import '../theme/app_colors.dart';

class HeroMovieSection extends StatelessWidget {
  final MovieModel movie;

  const HeroMovieSection({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Gunakan backdrop_path untuk gambar Hero
    final imageUrl = movie.backdropPath != null
        ? '${ApiConstants.BASE_IMAGE_URL}${movie.backdropPath}'
        : null;

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgGray,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Efek gelap agar teks terbaca
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      alignment: Alignment.bottomLeft,
      child: _buildDetails(context),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Tombol Play
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "Play",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 45),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Info/Detail
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline, color: AppColors.textWhite),
                label: const Text("Info", style: TextStyle(color: AppColors.textWhite)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(120, 45),
                  side: const BorderSide(color: AppColors.textWhite, width: 1.5),
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}