import 'package:get_it/get_it.dart';
import '../services/tmdb_services.dart';
import '../repositories/movie_repositoy.dart';

final locator = GetIt.instance;

void setupLocator() {
  //Registering Service
  locator.registerLazySingleton<TmdbService>(() => TmdbService());

  // Registering Repo yang butuh service
  locator.registerLazySingleton<MovieRepository>(
      () =>  MovieRepository(locator<TmdbService>()),
  );

  // ViewModels/Blocs/Cubit
}