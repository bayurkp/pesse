import 'package:flutter/material.dart';

class PesseBottomNavigationBar extends StatefulWidget {
  const PesseBottomNavigationBar({super.key});

  @override
  State<PesseBottomNavigationBar> createState() =>
      _PesseBottomNavigationBarState();
}

class _PesseBottomNavigationBarState extends State<PesseBottomNavigationBar> {
  var _selectedNavigationIndex = 0;

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

  int selectedNavigationIndex = 0;

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _navigationBarItems,
      onTap: _onNavigationTapped,
      currentIndex: _selectedNavigationIndex,
    );
  }
}
