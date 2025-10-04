import 'package:get_it/get_it.dart';
import '../services/tmdb_services.dart';
import '../repositories/movie_repositoy.dart';
import '../services/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  //Registering Service
  locator.registerLazySingleton<TmdbService>(() => TmdbService());

  // Registering Repo yang butuh service
  locator.registerLazySingleton<MovieRepository>(
      () =>  MovieRepository(locator<TmdbService>()),
  );

  locator.registerLazySingleton<AuthService>(() => AuthService());

  // ViewModels/Blocs/Cubit
}