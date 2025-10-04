// lib/screens/movie_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../core/api_constants.dart';
import '../theme/app_colors.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Ambil URL gambar backdrop (latar belakang)
    final backdropUrl = movie.backdropPath != null
        ? '${ApiConstants.BASE_IMAGE_URL}${movie.backdropPath}'
        : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. AppBar Fleksibel (Hero Image)
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true, // Biar AppBar tetap ada saat di-scroll
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: backdropUrl != null
                  ? Image.network(
                backdropUrl,
                fit: BoxFit.cover,
                // Tambahkan gradient di bawah gambar agar teks mudah dibaca
                alignment: Alignment.topCenter,
              )
                  : Container(color: AppColors.bgGray),
            ),
          ),

          // 2. Konten Detail Film
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRatingAndRelease(context),
                      const SizedBox(height: 20),

                      _buildActionButtons(context),
                      const SizedBox(height: 20),

                      Text(
                        'Sinopsis',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.textWhite),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textLight),
                        textAlign: TextAlign.justify,
                      ),

                      // Placeholder untuk informasi tambahan
                      const SizedBox(height: 40),
                      const Text('Cast & Crew (TODO)'),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Rating dan Tanggal Rilis
  Widget _buildRatingAndRelease(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rate_rounded, color: AppColors.accentYellow, size: 24),
        const SizedBox(width: 4),
        Text(
          '${(movie.voteAverage ?? 0.0).toStringAsFixed(1)}',
          style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        Text(
          movie.releaseDate != null ? movie.releaseDate!.split('-')[0] : 'TBA', // Ambil hanya tahun
          style: const TextStyle(color: AppColors.textLight, fontSize: 16),
        ),
      ],
    );
  }

  // Widget untuk Tombol Aksi
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () { /* TODO: Implementasi Pemutar Video */ },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () { /* TODO: Implementasi Tambah ke Daftar Saya (Firestore) */ },
          icon: const Icon(Icons.add, color: AppColors.textWhite, size: 30),
          tooltip: 'Tambah ke Daftar Saya',
        ),
      ],
    );
  }
}