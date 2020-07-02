import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum NavItemType { home, catalog, sell, cart, profile }

class NavPanel extends StatelessWidget {
  BottomNavigationBarItem getItem(NavItemType type) {
    final asset = itemAsset(type);
    final title = itemTitle(type);

    return BottomNavigationBarItem(
        icon: SizedBox(
          width: 28,
          height: 28,
          child: type != NavItemType.sell
              ? SvgPicture.asset(
                  asset,
                  color: Colors.black,
                )
              : SizedBox(),
        ),
        activeIcon: SizedBox(
          width: 28,
          height: 28,
          child: type != NavItemType.sell
              ? SvgPicture.asset(
                  asset,
                  color: Color(0xFFFAD24E),
                )
              : SizedBox(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: SizedBox(
              width: 75, height: 12, child: Center(child: Text(title))),
        ));
  }

  String itemAsset(NavItemType type) {
    switch (type) {
      case NavItemType.home:
        return "assets/home.svg";
      case NavItemType.catalog:
        return "assets/catalog.svg";
      case NavItemType.sell:
        return "assets/add.svg";
      case NavItemType.cart:
        return "assets/bag.svg";
      case NavItemType.profile:
        return "assets/profile.svg";

      default:
        throw UnimplementedError();
    }
  }

  String itemTitle(NavItemType type) {
    switch (type) {
      case NavItemType.home:
        return "Главная";
      case NavItemType.catalog:
        return "Каталог";
      case NavItemType.sell:
        return "Продать вещь";
      case NavItemType.cart:
        return "Корзина";
      case NavItemType.profile:
        return "Профиль";

      default:
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 6,
            ),
            BottomNavigationBar(
              items: [
                getItem(NavItemType.home),
                getItem(NavItemType.catalog),
                getItem(NavItemType.sell),
                getItem(NavItemType.cart),
                getItem(NavItemType.profile),
              ],
              currentIndex: 1,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              unselectedLabelStyle:
                  TextStyle(fontFamily: "SF UI", fontSize: 10),
              selectedLabelStyle: TextStyle(fontFamily: "SF UI", fontSize: 10),
              unselectedItemColor: Color(0xFF8E8E8E),
              selectedItemColor: Colors.black,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 36,
            height: 36,
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.black),
            child: Center(
              child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SvgPicture.asset(
                    "assets/small_add.svg",
                    color: Color(0xFFFAD24E),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
