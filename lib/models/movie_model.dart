import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final int id;
  final String title;

  // TMDB menggunakan snake_case, kita gunakan @JsonKey untuk memetakannya
  @JsonKey(name: 'poster_path')
  final String? posterPath; // Nullable karena terkadang poster hilang

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  final String overview;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(name: 'vote_average')
  final double voteAverage;

  // Properti untuk mengetahui apakah itu konten dewasa
  final bool adult;

  // Constructor
  MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.releaseDate,
    required this.voteAverage,
    required this.adult,
  });

  // 3. Factory constructor untuk deserialisasi JSON
  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  // 4. Metode untuk serialisasi JSON (opsional, tapi berguna)
  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}