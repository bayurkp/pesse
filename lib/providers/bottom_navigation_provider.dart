import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationNotifier extends ChangeNotifier {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _navigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Beranda',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Anggota',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.percent),
      label: 'Bunga',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];
  final List<String> _routeNames = [
    'home',
    'members.index',
    'interest',
    'profile',
  ];

  int get currentIndex => _currentIndex;
  List<BottomNavigationBarItem> get navigationBarItems => _navigationBarItems;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void navigate(BuildContext context, int index) {
    _currentIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(_routeNames[_currentIndex]);
      notifyListeners();
    });
  }
}
