// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/api_constants.dart';
import '../providers/search_provider.dart';
import '../theme/app_colors.dart';
import 'movie_detail_screen.dart'; // Untuk navigasi hasil klik

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // Clear search state saat screen/tab ditutup
    Provider.of<SearchProvider>(context, listen: false).clearSearch();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        automaticallyImplyLeading: false, // Jangan tampilkan tombol back
        toolbarHeight: 80,
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.searchState == SearchState.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentYellow));
          }

          if (provider.searchState == SearchState.error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          if (provider.searchResults.isEmpty && provider.searchState == SearchState.loaded) {
            return const Center(child: Text('Tidak ditemukan hasil film.'));
          }

          if (provider.searchState == SearchState.initial) {
            return const Center(child: Text('Cari film, acara TV, dan lainnya...'));
          }

          // Menampilkan Hasil Pencarian
          return ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];
              return ListTile(
                leading: movie.posterPath != null
                    ? Image.network(
                  '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}',
                  width: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.movie, color: AppColors.textLight),
                title: Text(movie.title),
                subtitle: Text(movie.releaseDate ?? ''),
                onTap: () {
                  // Navigasi ke Halaman Detail Film
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    // Menggunakan TextField kustom yang terintegrasi dengan provider
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.bgGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textWhite),
        decoration: const InputDecoration(
          hintText: 'Cari film atau acara TV...',
          hintStyle: TextStyle(color: AppColors.textLight),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: AppColors.textLight),
        ),
        onChanged: (query) {
          Provider.of<SearchProvider>(context, listen: false).performSearch(query);
        },
      ),
    );
  }
}