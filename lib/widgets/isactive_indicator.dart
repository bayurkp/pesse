import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';

class IsActiveIndicator extends StatelessWidget {
  final int isActive;

  const IsActiveIndicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
              color: isActive == 0 ? PesseColors.red : PesseColors.green,
              shape: BoxShape.circle),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 2.0),
          child: Text(
            isActive == 1 ? 'Aktif' : 'Tidak aktif',
          ),
        ),
      ],
    );
  }
}
