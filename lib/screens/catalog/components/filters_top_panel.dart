import 'package:flutter/material.dart';
import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/screens/catalog/components/sorting_title.dart';

import 'filters_title.dart';
import 'property_title.dart';

enum PanelType { filters, property, sorting }

class FiltersTopPanel extends StatelessWidget {
  final Function() onClose;
  final PanelType type;
  final Property property;

  const FiltersTopPanel(
      {Key key, this.type: PanelType.filters, this.property, this.onClose})
      : super(key: key);

  Widget title() {
    switch (type) {
      case PanelType.filters:
        return FiltersTitle(
          onClose: onClose,
        );
      case PanelType.property:
        return PropertyTitle(
          property: property,
        );
      case PanelType.sorting:
        return SortingTitle();

      default:
        return Text(
          "Неверный тип".toUpperCase(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 13,
        ),
        Container(
          width: 30,
          height: 3,
          decoration: ShapeDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
        ),
        title(),
      ],
    );
  }
}
