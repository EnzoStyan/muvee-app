// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie_model.dart';
import '../theme/app_colors.dart';
import '../widgets/hero_movie_section.dart';
import '../widgets/movie_category_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        switch (provider.trendingState) {
          case ViewState.loading:
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentYellow),
              ),
            );

          case ViewState.error:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Gagal memuat film: ${provider.errorMessage}. Cek koneksi atau API.',
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            );

          case ViewState.loaded:
            return _buildLoadedScreen(context, provider.trendingMovies);

          case ViewState.initial:
          default:
            return const Center(child: Text('Memuat data...'));
        }
      },
    );
  }

  Widget _buildLoadedScreen(BuildContext context, List<MovieModel> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text("Tidak ada film yang tersedia."));
    }

    final popularNow = movies.take(10).toList();
    final trending = movies.skip(5).take(10).toList();
    final topRated = movies.skip(15).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroMovieSection(movie: movies.first),

          const SizedBox(height: 20),

          if (popularNow.isNotEmpty)
            MovieCategoryRow(
              title: "Popular Now",
              movies: popularNow,
            ),

          const SizedBox(height: 20),

          if (trending.isNotEmpty)
            MovieCategoryRow(
              title: "Trending Movies",
              movies: trending,
            ),

          const SizedBox(height: 20),

          if (topRated.isNotEmpty)
            MovieCategoryRow(
              title: "Muvee's Top Picks",
              movies: topRated,
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}