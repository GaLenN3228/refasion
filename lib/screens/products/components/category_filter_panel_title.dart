import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';

class CategoryFilterPanelTitle extends StatelessWidget {
  final String categoryName;
  final Function() onReset;
  final Function() onClose;

  const CategoryFilterPanelTitle(
      {Key key, this.onReset, this.onClose, this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlidingPanelIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (onClose != null) onClose();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Вся одежда",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Text(
                categoryName != null
                    ? categoryName.toUpperCase()
                    : "Категория".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (onReset != null) onReset();
                },
                child: Text(
                  "Сбросить",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Color(0xFF959595)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
