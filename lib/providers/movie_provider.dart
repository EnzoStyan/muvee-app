// lib/providers/movie_provider.dart

import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

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
    // Hindari request berulang jika sudah loaded
    if (_trendingState == ViewState.loaded) return;

    _trendingState = ViewState.loading;
    notifyListeners();

    try {
      final movies = await _repository.getTrendingMovies();

      _trendingMovies = movies;
      _trendingState = ViewState.loaded;
      _errorMessage = '';

    } catch (e) {
      _trendingState = ViewState.error;
      // Mengambil pesan error yang lebih jelas
      _errorMessage = e.toString().contains(":") ? e.toString().split(':')[1].trim() : e.toString();
      debugPrint('Error fetching trending movies: $_errorMessage');
    }

    notifyListeners();
  }
}