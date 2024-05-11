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
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];
  final List<String> _routeNames = [
    'home',
    'members.index',
    'profile',
  ];

  int get currentIndex => _currentIndex;
  List<BottomNavigationBarItem> get navigationBarItems => _navigationBarItems;

  void navigate(BuildContext context, int index) {
    _currentIndex = index;
    context.goNamed(_routeNames[_currentIndex]);
    notifyListeners();
  }
}
