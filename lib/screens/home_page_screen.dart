import 'package:flutter/material.dart';
import 'package:tinder_for_movies/screens/movies_list_screen.dart';
import 'package:tinder_for_movies/screens/profile_screen.dart';

import 'package:tinder_for_movies/screens/swipe_screen.dart';





class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // Track which tab is selected

  // Define the pages for each tab
  final List<Widget> _pages = [
    const MoviesListScreen(),     // Your current Home content
    const SwipeScreen(),       // Replace with your actual SwipePage widget
    const ProfileScreen(),     // Replace with your actual ProfilePage widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: _pages[_currentIndex], // Display selected tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Color(0xFF303032),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.amp_stories),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}




