import '../models/movie_model.dart';
import '../services/tmdb_services.dart';
//import '../services/firebase_services.dart';

class MovieRepository {
  final TmdbService _tmdbService;

  MovieRepository(this._tmdbService);

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final movies = await _tmdbService.getPopularMovies();

      return movies;
    } catch (e) {
      throw Exception('Failed to fetch movies from repository: $e');
    }
  }
}