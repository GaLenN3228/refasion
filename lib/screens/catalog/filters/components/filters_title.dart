import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/components/sliding_panel_indicator.dart';

class FiltersTitle extends StatelessWidget {
  final Filter filter;
  final Function() onReset;
  final bool canReset;

  const FiltersTitle({Key key, this.onReset, this.canReset: false, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlidingPanelIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  "Закрыть",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Text(
                filter != null
                    ? filter.name.toUpperCase()
                    : "Фильтровать".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (canReset) onReset();
                },
                child: Text(
                  "Сбросить",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: filter != null
                          ? Colors.transparent
                          : canReset ? Colors.black : Color(0xFF959595)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
