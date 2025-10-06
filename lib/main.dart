import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'firebase_options.dart';
import 'di/locator.dart';
import 'theme/app_theme.dart';
import 'providers/movie_provider.dart';
import 'repositories/movie_repository.dart';
import 'services/auth_service.dart';
import 'screens/main_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'services/tmdb_service.dart';
import 'providers/search_provider.dart';
import 'providers/my_list_provider.dart';
import 'services/my_list_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("✅ Firebase Core Initialized Successfully!");

    setupLocator();

    await testTmdbService();

  } catch (e) {
    log("❌ Initialization Failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieProvider(locator<MovieRepository>()),
        ),

        StreamProvider<User?>.value(
          value: locator<AuthService>().user,
          initialData: null, // Initial state: tidak ada user
        ),

        Provider<AuthService>(
          create: (context) => locator<AuthService>(),
        ),

        ChangeNotifierProvider(
          create: (context) => SearchProvider(locator<MovieRepository>()),
        ),

        ChangeNotifierProvider(
          create: (context) => MyListProvider(locator<MyListService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> testTmdbService() async {
  log("\n--- Starting TMDB Service Test ---");
  try {
    final service = locator<TmdbService>();
    final movies = await service.getPopularMovies();

    log('✅ TMDB Service Test SUCCESS!');
    log('Total Movies Received: ${movies.length}');
    log('First Movie Title (Parsed Model): ${movies.first.title}');
  } catch (e) {
    log('❌ TMDB Service Test FAILED: $e');
  }
  log("--- TMDB Service Test Finished ---\n");
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    final myListProvider = Provider.of<MyListProvider>(context, listen: false);
    myListProvider.startListeningToMyList(user);

    if (user == null) {
      return const LoginScreen();
    } else {
      return const MainWrapper();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muvee App',
      theme: muveeTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}