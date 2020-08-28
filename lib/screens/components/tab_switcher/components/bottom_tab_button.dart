import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cart_count.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

enum BottomTab { home, catalog, cart, profile }

class BottomTabButton extends StatefulWidget {
  final BottomTab tab;
  final ValueNotifier<BottomTab> currentTab;
  final Function() customOnPush;

  const BottomTabButton(this.tab, {this.currentTab, this.customOnPush});

  @override
  _BottomTabButtonState createState() => _BottomTabButtonState();
}

class _BottomTabButtonState extends State<BottomTabButton> {
  String title;
  IconAsset icon;

  BottomTab currentTab;
  bool selected;

  @override
  void initState() {
    switch (widget.tab) {
      case BottomTab.home:
        title = "Главная";
        icon = IconAsset.home;
        break;
      case BottomTab.catalog:
        title = "Каталог";
        icon = IconAsset.catalog;
        break;
      case BottomTab.cart:
        title = "Корзина";
        icon = IconAsset.cart;
        break;
      case BottomTab.profile:
        title = "Профиль";
        icon = IconAsset.person;
        break;
      default:
        title = "Разместить вещь";
        break;
    }

    currentTab = widget.currentTab?.value;
    selected = currentTab != null && currentTab == widget.tab;

    widget.currentTab?.addListener(tabListener);

    super.initState();
  }

  tabListener() {
    final newTab = widget.currentTab?.value;

    setState(() {
      currentTab = newTab;
      selected = currentTab == widget.tab;
    });
  }

  @override
  void dispose() {
    widget.currentTab?.removeListener(tabListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.tab != null && widget.currentTab != null) if (widget
                .currentTab.value ==
            widget.tab)
          widget.currentTab.notifyListeners();
        else
          widget.currentTab.value = widget.tab;
        if (widget.customOnPush != null) widget.customOnPush();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 32,
            child: Stack(children: [
              widget.tab != null
                  ? SVGIcon(
                      icon: icon,
                      width: 34,
                      height: 34,
                      color: selected ? accentColor : primaryColor,
                    )
                  : SizedBox(),
              (widget.tab == BottomTab.cart)
                  ? Consumer<CartCountRepository>(
                      builder: (context, model, child) => model.cartCount != "0"
                          ? Positioned.fill(
                              child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: new BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    model.cartCount,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            fontFamily: "SF Compact Display",
                                            color:
                                                selected ? primaryColor : null),
                                  )),
                            ))
                          : SizedBox())
                  : SizedBox()
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 1),
            child: SizedBox(
                width: widget.tab != null ? 70 : 85,
                height: 12,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontFamily: "SF Compact Display",
                      color: selected ? primaryColor : null),
                )),
          ),
        ],
      ),
    );
  }
}
