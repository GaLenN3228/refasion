import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/components/filters_top_panel.dart';

class FiltersPanelContent extends StatelessWidget {
  final Function() onClose;

  const FiltersPanelContent({Key key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FiltersTopPanel(
      onClose: onClose,
      type: PanelType.filters,
    );
  }
}
