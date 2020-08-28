import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/screens/profile/profile.dart';

enum PanelType { search, item }

class TopPanel extends StatelessWidget {
  final bool canPop;
  final bool includeTopPadding;
  final Function() onSearch;
  final Function() onFavouritesClick;
  final PanelType type;

  const TopPanel(
      {Key key,
      this.canPop: false,
      this.type: PanelType.search,
      this.onSearch,
      this.includeTopPadding: true,
      this.onFavouritesClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: includeTopPadding ? MediaQuery.of(context).padding.top : 4, bottom: 4),
      child: Row(
        children: [
          canPop
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).pop(),
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
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: onSearch,
                            child: Text(
                              "Поиск",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.25)),
                            ),
                          ),
                          // FocusScope(
                          //     node: FocusScopeNode(),
                          //     child: TextField(
                          //       onChanged: (searchQuery) {
                          //         setState(() {
                          //           final queryResults = searchQuery
                          //                   .isEmpty
                          //               ? loadCatalogItems()
                          //               : loadCatalogItems()
                          //                   .where((catalog) => catalog
                          //                       .name
                          //                       .toLowerCase()
                          //                       .startsWith(searchQuery
                          //                           .toLowerCase()))
                          //                   .toList();
                          //           catalogs.addAll(queryResults);
                          //           print(queryResults.toString());
                          //         });
                          //       },
                          //       decoration: InputDecoration(
                          //         border: InputBorder.none,
                          //         hintText: "Поиск",
                          //       ),
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .headline1
                          //           .copyWith(
                          //               fontWeight: FontWeight.normal),
                          //     ))
                        ),
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
    );
  }
}
