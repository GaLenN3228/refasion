import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';

class FilterTileSlider extends StatefulWidget {
  final Filter filter;
  final Function(RangeValues) onChange;
  final int minStep;

  const FilterTileSlider(
      {Key key, this.filter, this.onChange, this.minStep: 100})
      : super(key: key);

  @override
  _FilterTileSliderState createState() => _FilterTileSliderState();
}

class _FilterTileSliderState extends State<FilterTileSlider> {
  List<double> values;
  double min;
  double max;

  RangeValues range;
  @override
  void initState() {
    values = widget.filter.values.map((e) => double.parse(e)).toList();
    min = values.reduce(math.min);
    max = values.reduce(math.max);
    range = RangeValues(min, max);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            widget.filter.name,
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
                    padding: const EdgeInsets.only(right: 5),
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(range.start.toInt().toString()),
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(range.end.toInt().toString()),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
        RangeSlider(
          values: range,
          min: min,
          max: max,
          activeColor: Color(0xFFFAD24E),
          inactiveColor: Color(0xFFE6E6E6),
          onChanged: (value) {
            final roundedValue = RangeValues(
                math
                    .max(min,
                        (value.start / widget.minStep).round() * widget.minStep)
                    .toDouble(),
                math
                    .min(max,
                        (value.end / widget.minStep).round() * widget.minStep)
                    .toDouble());
            setState(() {
              range = roundedValue;
            });
          },
          onChangeEnd: (value) {
            widget.onChange(value);
          },
        ),
      ],
    );
  }
}
