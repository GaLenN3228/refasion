import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/cart_count.dart';
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
  String asset;

  BottomTab currentTab;
  bool selected;

  @override
  void initState() {
    switch (widget.tab) {
      case BottomTab.home:
        title = "Главная";
        asset = "assets/home.svg";
        break;
      case BottomTab.catalog:
        title = "Каталог";
        asset = "assets/catalog.svg";
        break;
      case BottomTab.cart:
        title = "Корзина";
        asset = "assets/bag.svg";
        break;
      case BottomTab.profile:
        title = "Профиль";
        asset = "assets/profile.svg";
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
        if (widget.tab != null && widget.currentTab != null) if (widget.currentTab.value == widget.tab)
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
              SizedBox(
                width: 28,
                height: 28,
                child: widget.tab != null
                    ? SvgPicture.asset(
                        asset,
                        color: selected ? accentColor : primaryColor,
                      )
                    : SizedBox(),
              ),
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
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                        fontFamily: "SF Compact Display", color: selected ? primaryColor : null),
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
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontFamily: "SF Compact Display", color: selected ? primaryColor : null),
                )),
          ),
        ],
      ),
    );
  }
}