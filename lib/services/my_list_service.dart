// lib/services/my_list_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';
import 'dart:developer';

class MyListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan koleksi untuk pengguna saat ini
  CollectionReference get _userCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User is not signed in.');
    }
    // Struktur: users/{uid}/watchlist/{movie_id}
    return _firestore.collection('users').doc(uid).collection('watchlist');
  }

  // Cek apakah film sudah ada di daftar tontonan
  Future<bool> isInMyList(int movieId) async {
    try {
      final doc = await _userCollection.doc(movieId.toString()).get();
      return doc.exists;
    } catch (e) {
      log('Error checking watchlist: $e');
      return false;
    }
  }

  // Menambahkan film ke daftar tontonan
  Future<void> addToMyList(MovieModel movie) async {
    try {
      await _userCollection.doc(movie.id.toString()).set(movie.toJson());
    } catch (e) {
      log('Error adding to watchlist: $e');
      throw Exception('Failed to add movie to My List.');
    }
  }

  // Menghapus film dari daftar tontonan
  Future<void> removeFromMyList(int movieId) async {
    try {
      await _userCollection.doc(movieId.toString()).delete();
    } catch (e) {
      log('Error removing from watchlist: $e');
      throw Exception('Failed to remove movie from My List.');
    }
  }

  // Mengambil SEMUA film dari daftar tontonan pengguna
  Stream<List<MovieModel>> getMyListStream() {
    // Memastikan kita hanya mendengarkan jika ada pengguna yang masuk
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        .snapshots()
        .map((snapshot) {
      // Mengonversi setiap dokumen Firestore menjadi MovieModel
      return snapshot.docs
          .map((doc) => MovieModel.fromJson(doc.data()))
          .toList();
    });
  }
}