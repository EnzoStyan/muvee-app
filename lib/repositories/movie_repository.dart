// lib/repositories/movie_repository.dart

import '../models/movie_model.dart';
import '../services/tmdb_service.dart';

class MovieRepository {
  final TmdbService _tmdbService;

  MovieRepository(this._tmdbService);

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final movies = await _tmdbService.getPopularMovies();
      return movies;
    } catch (e) {
      // Repositori hanya meneruskan error dari service
      throw Exception('Failed to fetch movies from repository: $e');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    // Jangan izinkan pencarian dengan query kosong
    if (query.trim().isEmpty) {
      return [];
    }
    try {
      final movies = await _tmdbService.searchMovies(query);
      return movies;
    } catch (e) {
      throw Exception('Failed to search movies from repository: $e');
    }
  }
}