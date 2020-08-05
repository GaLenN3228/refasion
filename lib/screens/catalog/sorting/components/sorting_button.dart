import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/sort.dart';
import 'package:refashioned_app/screens/catalog/sorting/sorting_panel.dart';

import '../../../../utils/colors.dart';

class SortingButton extends StatefulWidget {
  final Function() onUpdate;
  final Sort sort;

  const SortingButton({Key key, this.onUpdate, this.sort}) : super(key: key);

  @override
  _SortingButtonState createState() => _SortingButtonState();
}

class _SortingButtonState extends State<SortingButton> {
  onUpdate() => setState(() => widget.onUpdate());

  showSorting(BuildContext context) {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        useRootNavigator: true,
        builder: (context, controller) => SortingPanel(widget.sort, onUpdate));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showSorting(context),
        child: Row(
          children: [
            Text(
              widget.sort.methods.elementAt(widget.sort.index)?.name ??
                  "Не выбран",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            SvgPicture.asset(
              "assets/sort.svg",
              width: 24,
              color: primaryColor,
            ),
          ],
        ));
  }
}
