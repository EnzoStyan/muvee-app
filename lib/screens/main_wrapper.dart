import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Home Screen (dengan data film)
    const Center(child: Text("Search Screen", style: TextStyle(color: AppColors.textWhite))),
    const Center(child: Text("Downloads Screen", style: TextStyle(color: AppColors.textWhite))),
    const Center(child: Text("My List Screen", style: TextStyle(color: AppColors.textWhite))),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MovieProvider>(context, listen: false).fetchTrendingMovies()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muvee', style: TextStyle(color: AppColors.accentYellow)),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.cast, color: AppColors.textWhite,))
        ],
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
          type: BottomNavigationBarType.fixed, // Penting untuk latar belakang dark
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.file_download), label: 'Downloads'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My List'),
        ],
      ),
    );
  }
}