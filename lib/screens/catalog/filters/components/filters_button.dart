import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class FiltersButton extends StatelessWidget {
  final Function() onApply;
  final String root;
  final String categoryId;
  final Function(String url, String title) openInfoWebViewBottomSheet;

  const FiltersButton({Key key, this.onApply, this.root, this.categoryId, this.openInfoWebViewBottomSheet}) : super(key: key);

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
                  openInfoWebViewBottomSheet: openInfoWebViewBottomSheet,
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
