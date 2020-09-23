import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class FiltersButton extends StatelessWidget {
  final Function() onApply;
  final String root;
  final String categoryId;

  const FiltersButton({Key key, this.onApply, this.root, this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
              showCupertinoModalBottomSheet(
                useRootNavigator: true,
                expand: true,
                context: context,
                builder: (context, controller) => FiltersPanel(
                  root: root,
                  scrollController: controller,
                  updateProducts: onApply,
                  categoryId: categoryId,
                ),
              );
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Фильтровать",
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
            ),
            RotatedBox(
              quarterTurns: 2,
              child: SVGIcon(
                icon: IconAsset.back,
                size: 14,
              ),
            ),
          ],
        ));
  }
}
