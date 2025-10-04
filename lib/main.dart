import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muvee_app/di/locator.dart';
import 'dart:developer';
import 'firebase_options.dart';
import 'services/tmdb_services.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'di/locator.dart';
import 'providers/movie_provider.dart';
import 'repositories/movie_repositoy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("✅ Firebase Core Initialized Successfully!"); // Menggunakan log

    setupLocator();
    await testTmdbService();

  } catch (e) {
    log("❌ Firebase Initialization Failed: $e");
  }
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => MovieProvider(locator<MovieRepository>()),
      )
    ],
      child: const MyApp(),
    ),
  );
}

Future<void> testTmdbService() async {
  log("\n--- Starting TMDB Service Test ---");
  try {
    final service = TmdbService();
    final movies = await service.getPopularMovies();

    log('✅ TMDB Service Test SUCCESS!');
    log('Total Movies Received: ${movies.length}');
    log('First Movie Title (Parsed Model): ${movies.first.title}');
    log('First Movie Overview: ${movies.first.overview.substring(0, 50)}...');

  } catch (e) {
    log('❌ TMDB Service Test FAILED: $e');
  }
  log("--- TMDB Service Test Finished ---\n");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: muveeTheme,

      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Text('Wellcome to Muvee',
        style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

