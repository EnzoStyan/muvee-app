import 'package:flutter/material.dart';
import 'dart:async';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

enum SearchState { initial, loading, loaded, error }

class SearchProvider with ChangeNotifier {
  final MovieRepository _repository;

  List<MovieModel> _searchResults = [];
  SearchState _searchState = SearchState.initial;
  String _errorMessage = '';

  SearchProvider(this._repository);

  List<MovieModel> get searchResults => _searchResults;
  SearchState get searchState => _searchState;
  String get errorMessage => _errorMessage;

  // Debouncer untuk mencegah request API terlalu banyak saat user mengetik
  Timer? _debounce;

  Future<void> performSearch(String query) async {
    // Hapus timer lama jika user mengetik lagi dengan cepat
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Set debounce selama 500ms
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        _searchResults = [];
        _searchState = SearchState.initial;
        notifyListeners();
        return;
      }

      _searchState = SearchState.loading;
      notifyListeners();

      try {
        final movies = await _repository.searchMovies(query);

        _searchResults = movies;
        _searchState = SearchState.loaded;
        _errorMessage = '';

      } catch (e) {
        _searchState = SearchState.error;
        _errorMessage = e.toString().split(':')[1].trim();
        debugPrint('Error performing search: $_errorMessage');
      }
      notifyListeners();
    });
  }

  // Clear state saat screen ditutup
  void clearSearch() {
    _searchResults = [];
    _searchState = SearchState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}