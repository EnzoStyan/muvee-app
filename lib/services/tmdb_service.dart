import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/movie_model.dart';

class TmdbService {

  Future<List<MovieModel>> getPopularMovies() async {
    final url = Uri.parse(
        '${ApiConstants.BASE_URL}movie/popular?api_key=${ApiConstants.API_KEY}'
    );

    log('--- TMDB Request URL: $url ---'); // Logging URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);
        final List results = jsonBody['results'];

        return results.map((e) => MovieModel.fromJson(e)).toList();
      } catch (e) {
        log('❌ JSON Parsing Error: $e');
        // Melempar exception yang lebih jelas jika parsing gagal
        throw Exception('Failed to parse movie data. Detail: $e');
      }
    } else {
      // Melempar exception yang lebih jelas jika status non-200
      log('❌ TMDB Status Error: ${response.statusCode}');
      throw Exception(
          'TMDB API failed with status: ${response.statusCode}. Body: ${response
              .body}');
    }
  }
  Future<List<MovieModel>> searchMovies(String query) async {
    // Encoding query agar aman untuk URL (misal: 'The Godfather' jadi 'The%20Godfather')
    final encodedQuery = Uri.encodeComponent(query);

    final url = Uri.parse(
        '${ApiConstants.BASE_URL}search/movie?api_key=${ApiConstants.API_KEY}&query=$encodedQuery'
    );

    log('--- TMDB Search URL: $url ---');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);
        final List results = jsonBody['results'];

        // Menggunakan MovieModel yang sama untuk hasil pencarian
        return results.map((e) => MovieModel.fromJson(e)).toList();

      } catch (e) {
        log('❌ JSON Parsing Error (Search): $e');
        throw Exception('Failed to parse search data. Detail: $e');
      }

    } else {
      log('❌ TMDB Search Status Error: ${response.statusCode}');
      throw Exception('TMDB Search API failed with status: ${response.statusCode}');
    }
  }
}
