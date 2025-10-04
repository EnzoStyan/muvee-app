import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/movie_model.dart';

class TmdbService {
  Future<List<MovieModel>> getPopularMovies() async {
    final url = Uri.parse('${ApiConstants.BASE_URL}movie/popular?api_key=${ApiConstants.API_KEY}'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      final List results = jsonBody['results'];

      return results.map((e) => MovieModel.fromJson(e)).toList();
    }else{
      throw Exception('Failed to load popular movies. Status: ${response.statusCode}');
    }
  }
}