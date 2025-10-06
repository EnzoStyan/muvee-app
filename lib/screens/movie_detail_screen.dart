// lib/screens/movie_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../core/api_constants.dart';
import '../theme/app_colors.dart';
import '../providers/my_list_provider.dart'; // Import provider My List

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  backdropUrl != null
                      ? Image.network(
                    backdropUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )
                      : Container(color: AppColors.bgGray),
                  // Gradient Overlay untuk membuat teks mudah dibaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primaryDark,
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
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
                      _buildRatingAndRelease(), // Tidak perlu context
                      const SizedBox(height: 20),

                      _buildActionButtons(context),
                      const SizedBox(height: 30),

                      // Sinopsis
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
  Widget _buildRatingAndRelease() {
    return Row(
      children: [
        const Icon(Icons.star_rate_rounded, color: AppColors.accentYellow, size: 24),
        const SizedBox(width: 4),
        Text(
          // Penanganan null safety dengan operator ?? (Null Coalescing)
          '${(movie.voteAverage ?? 0.0).toStringAsFixed(1)}',
          style: const TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        Text(
          // Ambil hanya tahun, jika null tampilkan 'TBA'
          movie.releaseDate != null && movie.releaseDate!.isNotEmpty ? movie.releaseDate!.split('-')[0] : 'TBA',
          style: const TextStyle(color: AppColors.textLight, fontSize: 16),
        ),
      ],
    );
  }

  // Widget untuk Tombol Aksi (Play dan Add to My List)
  Widget _buildActionButtons(BuildContext context) {
    // Gunakan Consumer untuk mendengarkan status MyListProvider
    return Consumer<MyListProvider>(
      builder: (context, myListProvider, child) {
        final bool isAdded = myListProvider.isMovieInList(movie.id);

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur Pemutar Video (TODO)")),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Tombol Tambah/Hapus ke My List
            IconButton(
              onPressed: () {
                myListProvider.toggleMyList(movie);
              },
              icon: Icon(
                isAdded ? Icons.check : Icons.add, // Ganti ikon jika sudah ditambahkan
                color: isAdded ? AppColors.accentYellow : AppColors.textWhite,
                size: 30,
              ),
              tooltip: isAdded ? 'Hapus dari Daftar' : 'Tambah ke Daftar Saya',
            ),
          ],
        );
      },
    );
  }
}