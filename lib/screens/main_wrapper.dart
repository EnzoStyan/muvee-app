// lib/screens/main_wrapper.dart

import 'package:flutter/material.dart';
import 'package:muvee_app/screens/my_list_screen.dart';
import 'package:muvee_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // INDEX 0
    const SearchScreen(),
    const Center(child: Text("Downloads Screen", style: TextStyle(color: AppColors.textWhite))),
    const MyListScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    // Panggil data saat wrapper dimuat
    Future.microtask(() =>
        Provider.of<MovieProvider>(context, listen: false).fetchTrendingMovies()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muvee', style: TextStyle(color: AppColors.accentYellow)),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.cast, color: AppColors.textWhite)),
          // Tombol Logout
          IconButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).signOut();
              },
              icon: Icon(Icons.logout, color: AppColors.textWhite)
          ),
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
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.file_download), label: 'Downloads'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My List'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}