import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

enum BottomTab { home, catalog, cart, profile }

class BottomTabButton extends StatefulWidget {
  final BottomTab tab;
  final ValueNotifier<BottomTab> currentTab;
  final Function() customOnPush;
  final Function() onTabRefresh;

  const BottomTabButton(this.tab, {this.currentTab, this.customOnPush, this.onTabRefresh});

  @override
  _BottomTabButtonState createState() => _BottomTabButtonState();
}

class _BottomTabButtonState extends State<BottomTabButton> {
  String title;
  IconAsset icon;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentTab != null)
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.customOnPush != null)
            widget.customOnPush();
          else if (widget.currentTab.value == widget.tab && widget.onTabRefresh != null)
            widget.onTabRefresh();
          else
            widget.currentTab.value = widget.tab;
        },
        child: ValueListenableBuilder(
          valueListenable: widget.currentTab,
          builder: (context, value, child) {
            final selected = value == widget.tab;

            return Column(
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
                        ? Consumer<CartRepository>(
                            builder: (context, model, child) {
                              final count = model?.response?.content?.productsCount;

                              if (count == null || count == 0) return SizedBox();

                              return Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: new BoxDecoration(
                                      color: selected ? primaryColor : accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      count.toString(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          fontFamily: "SF Compact Display",
                                          color: selected ? accentColor : primaryColor),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
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
            );
          },
        ),
      );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
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
                      color: primaryColor,
                    )
                  : SizedBox(),
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
                      ),
                )),
          ),
        ],
      ),
    );
  }
}
