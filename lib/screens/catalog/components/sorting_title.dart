import 'package:flutter/material.dart';

class SortingTitle extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Text(
        "Сортировать".toUpperCase(),
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
