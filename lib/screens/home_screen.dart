import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../theme/app_colors.dart';
import '../models/movie_model.dart';
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
                  'Gagal memuat film: ${provider.errorMessage}. Cek koneksi atau API Key.',
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (movies.isNotEmpty)
            HeroMovieSection(movie: movies.first),


          const SizedBox(height: 20),


          MovieCategoryRow(
            title: "Popular Now",
            movies: movies,
          ),

          // 3. Kategori Film Horizontal Kedua (Movies for You - Placeholder)
          const SizedBox(height: 10),
          MovieCategoryRow(
            title: "Muvee Originals",
            movies: movies.reversed.toList(), // Contoh: gunakan daftar terbalik
          ),

          // Tambahkan SizedBox untuk jarak agar Bottom Nav tidak terpotong
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}