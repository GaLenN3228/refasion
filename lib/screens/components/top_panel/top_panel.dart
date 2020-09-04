import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/screens/profile/profile.dart';

enum PanelType { search, item }

class TopPanel extends StatelessWidget {
  bool canPop;
  final Function(String) onSearch;
  final Function() onFavouritesClick;
  final Function() onPop;
  final PanelType type;
  final TextEditingController textEditController;

  TopPanel(
      {Key key,
      this.canPop: false,
      this.type: PanelType.search,
      this.onSearch,
      this.onFavouritesClick,
      this.onPop,
      this.textEditController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 4, bottom: 4),
          child: Row(
            children: [
              canPop
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => onPop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SVGIcon(
                          icon: IconAsset.back,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 20,
                    ),
              Expanded(
                child: type == PanelType.search
                    ? Container(
                        height: 35,
                        decoration: ShapeDecoration(
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 5, 5, 8),
                              child: SVGIcon(
                                icon: IconAsset.search,
                                size: 20,
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                            Expanded(
                                child: FocusScope(
                                    node: FocusScopeNode(),
                                    child: TextField(
                                      controller: textEditController,
                                      onChanged: (searchQuery) {
                                        onSearch(searchQuery);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Поиск",
                                      ),
                                      style:
                                          Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.normal),
                                    ))),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
              GestureDetector(
                onTap: () => {
                  BaseRepository.isAuthorized().then((isAuthorized) {
                    isAuthorized
                        ? onFavouritesClick()
                        : showCupertinoModalBottomSheet(
                            backgroundColor: Colors.white,
                            expand: false,
                            settings: RouteSettings(name: "/authorization"),
                            context: context,
                            useRootNavigator: true,
                            builder: (context, controller) => ProfilePage());
                  })
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SVGIcon(
                    icon: IconAsset.favoriteBorder,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
