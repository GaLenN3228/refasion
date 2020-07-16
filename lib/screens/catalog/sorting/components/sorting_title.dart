import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';

class SortingTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlidingPanelIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            "Сортировать".toUpperCase(),
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ],
    );
  }
}
