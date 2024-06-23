import 'package:flutter/material.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:provider/provider.dart';

class PesseBottomNavigationBar extends StatelessWidget {
  const PesseBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationNotifier>(
      builder: (context, nav, child) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: PesseColors.surface,
              ),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: nav.navigationBarItems,
            onTap: (int index) {
              nav.navigate(context, index);
            },
            currentIndex: nav.currentIndex,
          ),
        );
      },
    );
  }
}
