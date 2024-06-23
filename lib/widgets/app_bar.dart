import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool hideLogo;

  const PesseAppBar({
    super.key,
    required this.title,
    this.hideLogo = false,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PesseColors.transparent,
      surfaceTintColor: PesseColors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Builder(
            builder: (context) {
              if (hideLogo) {
                return const SizedBox();
              }
              return Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/min_logo.svg',
                    semanticsLabel: 'Pesse\'s Logo',
                    height: 25.0,
                  ),
                  const SizedBox(width: 10.0),
                ],
              );
            },
          ),
          Text(
            title,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
