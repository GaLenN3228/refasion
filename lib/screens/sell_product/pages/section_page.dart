import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/sell_product/components/section_tile.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SectionPage extends StatelessWidget {
  final List<Category> sections;

  final Function() onClose;
  final Function(Category) onPush;

  const SectionPage({this.onPush, this.sections, this.onClose})
      : assert(sections != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.sellerPage(
              titleText: "Добавить вещь",
              rightAction: onClose,
              headerText: "Для кого ваша вещь?",
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: sections
                  .map((section) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 23.5),
                        child: SectionTile(
                          section: section,
                          onPush: onPush,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
