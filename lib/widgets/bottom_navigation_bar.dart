import 'package:flutter/material.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';

class PesseBottomNavigationBar extends StatelessWidget {
  const PesseBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationNotifier>(
      builder: (context, nav, child) {
        return BottomNavigationBar(
          items: nav.navigationBarItems,
          onTap: (int index) {
            nav.navigate(context, index);
          },
          currentIndex: nav.currentIndex,
        );
      },
    );
  }
}
