// lib/providers/my_list_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/movie_model.dart';
import '../services/my_list_service.dart';

class MyListProvider with ChangeNotifier {
  final MyListService _service;

  List<MovieModel> _myList = [];
  bool _isLoading = false;
  StreamSubscription? _listSubscription;

  MyListProvider(this._service);

  List<MovieModel> get myList => _myList;
  bool get isLoading => _isLoading;

  // ⭐️ Inisialisasi listener stream saat pengguna login ⭐️
  void startListeningToMyList(User? user) {
    _listSubscription?.cancel(); // Batalkan listener lama jika ada

    if (user != null) {
      _isLoading = true;
      _listSubscription = _service.getMyListStream().listen((movies) {
        _myList = movies;
        _isLoading = false;
        notifyListeners();
      });
    } else {
      _myList = [];
      notifyListeners();
    }
  }

  // Tambah/Hapus (Toggle)
  Future<void> toggleMyList(MovieModel movie) async {
    final bool isAdded = _myList.any((m) => m.id == movie.id);

    if (isAdded) {
      await _service.removeFromMyList(movie.id);
    } else {
      await _service.addToMyList(movie);
    }
    // Karena kita menggunakan Stream, data akan diperbarui secara otomatis
  }

  bool isMovieInList(int movieId) {
    return _myList.any((m) => m.id == movieId);
  }

  @override
  void dispose() {
    _listSubscription?.cancel();
    super.dispose();
  }
}