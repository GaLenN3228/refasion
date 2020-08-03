import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_price_input.dart';
import 'package:refashioned_app/utils/colors.dart';

class FilterTileSlider extends StatefulWidget {
  final Filter filter;
  final Function() onUpdate;
  final double offset;

  const FilterTileSlider(
      {Key key, this.filter, this.onUpdate, this.offset: 10000})
      : super(key: key);

  @override
  _FilterTileSliderState createState() => _FilterTileSliderState();
}

class _FilterTileSliderState extends State<FilterTileSlider> {
  unfocus() {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filter.prices == null || widget.filter.prices.isEmpty)
      return SizedBox();

    final min = widget.filter.prices['min'] ?? 0.0;
    final max = widget.filter.prices['max'] ?? 100000.0;

    final lower = widget.filter.prices['lower'];
    final upper = widget.filter.prices['upper'];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: unfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
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
                FilterPriceInput(
                    type: PriceType.lower,
                    onChanged: (text) {
                      final newLower = double.tryParse(text)
                              .clamp(min, (upper ?? max) - widget.offset) ??
                          min;

                      print("newLower: " + newLower.toString());

                      widget.filter.update(lower: newLower);
                      widget.onUpdate();
                    },
                    value: lower,
                    limit: min,
                    modified: widget.filter.modifiedMin),
                FilterPriceInput(
                    type: PriceType.upper,
                    onChanged: (text) {
                      final newUpper = double.tryParse(text)
                              .clamp((lower ?? min) + widget.offset, max) ??
                          max;

                      print("newUpper: " + newUpper.toString());

                      widget.filter.update(upper: newUpper);
                      widget.onUpdate();
                    },
                    value: upper,
                    limit: max,
                    modified: widget.filter.modifiedMax),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            child: FlutterSlider(
              rangeSlider: true,
              values: [lower ?? min, upper ?? max],
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
              minimumDistance: widget.offset,
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
                unfocus();
                setState(() {
                  widget.filter.update(lower: lowerValue, upper: upperValue);
                });
              },
              onDragCompleted: (handlerIndex, lowerValue, upperValue) =>
                  widget.onUpdate(),
            ),
          ),
        ],
      ),
    );
  }
}
