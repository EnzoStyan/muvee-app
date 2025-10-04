// lib/models/movie_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final int id;
  final String title;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  final String overview;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(name: 'vote_average')
  final double? voteAverage; // Nullable

  final bool? adult; // Nullable

  MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.releaseDate,
    this.voteAverage,
    this.adult,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}