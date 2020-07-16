import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/utils/colors.dart';

class FilterTileSlider extends StatelessWidget {
  final Filter original;
  final Filter modified;
  final Function(Filter) onChange;

  const FilterTileSlider({Key key, this.original, this.onChange, this.modified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (original.numericValues == null || original.numericValues.isEmpty)
      return SizedBox();

    final values = original.numericValues
        .map((filterValue) => double.parse(filterValue))
        .toList();

    final min = values.reduce(math.min);
    final max = values.reduce(math.max);

    final lower = ValueNotifier<int>(min.toInt());
    final upper = ValueNotifier<int>(max.toInt());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Text(
            original.name,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      "От",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                      width: 135,
                      height: 35,
                      decoration: ShapeDecoration(
                          color: Color(0xFFF6F6F6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ValueListenableBuilder(
                              valueListenable: lower,
                              builder: (context, lowerValue, _) => Text(
                                lowerValue.toString() + " ₽",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: primaryColor.withOpacity(0.25)),
                              ),
                            ),
                          ))),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      "До",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                      width: 135,
                      height: 35,
                      decoration: ShapeDecoration(
                          color: Color(0xFFF6F6F6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ValueListenableBuilder(
                              valueListenable: upper,
                              builder: (context, upperValue, _) => Text(
                                upperValue.toString() + " ₽",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: primaryColor.withOpacity(0.25)),
                              ),
                            )),
                      )),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 24, 10, 22),
          child: FlutterSlider(
            rangeSlider: true,
            values: values,
            max: max,
            min: min,
            selectByTap: false,
            tooltip: FlutterSliderTooltip(disabled: true),
            trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 3.0,
                activeTrackBar:
                    BoxDecoration(color: accentColor.withOpacity(0.5)),
                inactiveTrackBarHeight: 3.0,
                inactiveTrackBar: BoxDecoration(color: Color(0xFFE6E6E6))),
            handlerWidth: 20.0,
            handlerHeight: 20.0,
            handler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                          blurRadius: 10.0,
                          offset: Offset(0, 2),
                          color: Colors.black.withOpacity(0.15))
                    ],
                    shape: CircleBorder(
                        side: BorderSide(color: accentColor, width: 3))),
              ),
            ),
            rightHandler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                          blurRadius: 10.0,
                          offset: Offset(0, 2),
                          color: Colors.black.withOpacity(0.15))
                    ],
                    shape: CircleBorder(
                        side: BorderSide(color: accentColor, width: 3))),
              ),
            ),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              lower.value = lowerValue.toInt();
              upper.value = upperValue.toInt();
            },
            onDragCompleted: (handlerIndex, lowerValue, upperValue) {
              final newFilter = Filter(
                  name: original.name,
                  parameterName: original.parameterName,
                  type: original.type,
                  numericValues: [
                    lowerValue.toInt().toString(),
                    upperValue.toInt().toString(),
                  ]);

              onChange(newFilter);
            },
          ),
        ),
      ],
    );
  }
}
