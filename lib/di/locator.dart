// lib/di/locator.dart

import 'package:get_it/get_it.dart';
import '../services/tmdb_service.dart';
import '../repositories/movie_repository.dart';
import '../services/auth_service.dart';
import '../services/my_list_service.dart';
import '../providers/my_list_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  // SERVICES
  locator.registerLazySingleton<TmdbService>(() => TmdbService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<MyListService>(() => MyListService());

  // REPOSITORIES
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepository(locator<TmdbService>()),
  );

}