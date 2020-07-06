import 'package:flutter/material.dart';

class CategoryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 1,
        color: Color(0xFFE6E6E6),
      ),
    );
  }
}
