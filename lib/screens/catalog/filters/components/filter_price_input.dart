import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum PriceType { lower, upper }

class FilterPriceInput extends StatelessWidget {
  final PriceType type;
  final double value;
  final double limit;
  final Function(double) onUpdate;

  const FilterPriceInput(
      {Key key, this.type, this.value, this.limit, this.onUpdate})
      : super(key: key);

  static const _labels = {PriceType.lower: "От", PriceType.upper: "До"};

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            _labels[type],
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
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              (value ?? limit).toInt().toString() + " ₽",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: primaryColor.withOpacity(0.25)),
            )),
      ],
    );
  }
}
