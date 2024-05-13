import 'package:flutter/material.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesse'),
      ),
      body: Container(
        child: const Text('Home Screen'),
      ),
      bottomNavigationBar: PesseBottomNavigationBar(),
    );
  }
}
