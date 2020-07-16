import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';

class FiltersTitle extends StatelessWidget {
  final Filter filter;
  final Function() onReset;
  final bool filtersChanged;

  const FiltersTitle(
      {Key key, this.onReset, this.filtersChanged: false, this.filter})
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
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  width: 72,
                  child: Text(
                    "Закрыть",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
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
                  if (filtersChanged) onReset();
                },
                child: Text(
                  "Сбросить",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: filter != null
                          ? Colors.transparent
                          : filtersChanged ? Colors.black : Color(0xFF959595)),
                ),
              ),
              // filtersChanged != null
              //     ? ValueListenableBuilder(
              //         valueListenable: filtersChanged,
              //         builder: (context, value, _) {
              //           return GestureDetector(
              //             behavior: HitTestBehavior.translucent,
              //             onTap: () {
              //               if (value) onReset();
              //             },
              //             child: Text(
              //               "Сбросить",
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .bodyText1
              //                   .copyWith(
              //                       color: value
              //                           ? Colors.black
              //                           : Color(0xFF959595)),
              //             ),
              //           );
              //         },
              //       )
              //     : SizedBox(
              //         width: 72,
              //         height: 2,
              //       ),
            ],
          ),
        ),
      ],
    );
  }
}
