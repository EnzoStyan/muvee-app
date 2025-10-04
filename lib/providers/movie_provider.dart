import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../repositories/movie_repositoy.dart';

enum ViewState { initial, loading, loaded, error }

class MovieProvider with ChangeNotifier {
  final MovieRepository _repository;

  List<MovieModel> _trendingMovies = [];
  ViewState _trendingState = ViewState.initial;
  String _errorMessage = '';

  MovieProvider(this._repository);

  List<MovieModel> get trendingMovies => _trendingMovies;
  ViewState get trendingState => _trendingState;
  String get errorMessage => _errorMessage;

  Future<void> fetchTrendingMovies() async {
    if (_trendingState == ViewState.loaded || _trendingState == ViewState.loading) return;

    _trendingState = ViewState.loading;
    notifyListeners();

    try {
      final movies = await _repository.getTrendingMovies();

      _trendingMovies = movies;
      _trendingState = ViewState.error;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _trendingState = ViewState.error;
      debugPrint('error fetching trending Movies: $e');
    }
  }

}