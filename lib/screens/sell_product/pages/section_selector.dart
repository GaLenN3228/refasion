import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/section_tile.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class SectionSelector extends StatelessWidget {
  final Function(Category) onPush;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final List<Category> categories;

  const SectionSelector(
      {Key key,
      this.onPush,
      this.categories,
      this.animation,
      this.secondaryAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            SellProductTopBar(
              canPop: false,
            ),
            Header(
              text: "Для кого ваша вещь?",
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: categories
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
      ),
    );
  }
}
