import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';

class FiltersTitle extends StatelessWidget {
  final Filter filter;
  final Function() onReset;
  final Function() onClose;
  final bool canReset;

  const FiltersTitle(
      {Key key, this.onReset, this.canReset: false, this.filter, this.onClose})
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
                  if (canReset && onReset != null) onReset();
                },
                child: Text(
                  "Сбросить",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Color(0xFF959595)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
