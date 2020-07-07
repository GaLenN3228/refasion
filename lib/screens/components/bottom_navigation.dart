import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/utils/colors.dart';

enum TabItem { home, catalog, sell, cart, profile }

Map<TabItem, String> tabName = {
  TabItem.home: 'Главная',
  TabItem.catalog: 'Каталог',
  TabItem.sell: 'Продащь вещь',
  TabItem.cart: 'Корзина',
  TabItem.profile: 'Профиль',
};

Map<TabItem, String> assetName = {
  TabItem.home: "assets/home.svg",
  TabItem.catalog: "assets/catalog.svg",
  TabItem.sell: "assets/add.svg",
  TabItem.cart: "assets/bag.svg",
  TabItem.profile: "assets/profile.svg",
};

class BottomNavigation extends StatefulWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 1;

  selectIndex(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 6,
              ),
              BottomNavigationBar(
                items: [
                  _buildItem(context, tabItem: TabItem.home),
                  _buildItem(context, tabItem: TabItem.catalog),
                  _buildItem(context, tabItem: TabItem.sell),
                  _buildItem(context, tabItem: TabItem.cart),
                  _buildItem(context, tabItem: TabItem.profile),
                ],
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Color(0xFF8E8E8E),
                selectedItemColor: primaryColor,
                selectedLabelStyle: Theme.of(context).textTheme.caption,
                unselectedLabelStyle: Theme.of(context).textTheme.caption,
                onTap: (index) {
                  selectIndex(index);
                  widget.onSelectTab(
                    TabItem.values[index],
                  );
                },
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
      ),
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, {TabItem tabItem}) {
    String title = tabName[tabItem];
    String asset = assetName[tabItem];

    return BottomNavigationBarItem(
        icon: SizedBox(
          width: 28,
          height: 28,
          child: tabItem != TabItem.sell
              ? SvgPicture.asset(
                  asset,
                  color: Colors.black,
                )
              : SizedBox(),
        ),
        activeIcon: SizedBox(
          width: 28,
          height: 28,
          child: tabItem != TabItem.sell
              ? SvgPicture.asset(
                  asset,
                  color: Color(0xFFFAD24E),
                )
              : SizedBox(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: SizedBox(
              width: 75,
              height: 12,
              child: Center(
                  child: Text(
                title,
              ))),
        ));
  }
}
