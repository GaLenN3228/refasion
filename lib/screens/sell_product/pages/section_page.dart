import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/sell_product/components/section_tile.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SectionPage extends StatelessWidget {
  final Function(Category) onPush;
  final Function() onClose;
  final List<Category> categories;

  const SectionPage({this.onPush, this.categories, this.onClose})
      : assert(categories != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          RefashionedTopBar(
            leftButtonType: TBButtonType.none,
            middleType: TBMiddleType.title,
            middleTitleText: "Добавить вещь",
            rightButtonType: TBButtonType.text,
            rightButtonText: "Закрыть",
            rightButtonAction: onClose,
            bottomType: TBBottomType.header,
            bootomHeaderText: "Для кого ваша вещь?",
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
    );
  }
}
