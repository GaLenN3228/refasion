import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/profile/profile.dart';

enum PanelType { SEARCH_UNFOCUSED, SEARCH_FOCUSED }

class TopPanel extends StatefulWidget {
  final Function(String) onSearch;
  final Function() onFavouritesClick;
  final Function() onPop;
  final Function() onCancelClick;
  final PanelType type;
  final TextEditingController textEditController;

  TopPanel(
      {Key key,
      this.type: PanelType.SEARCH_FOCUSED,
      this.onSearch,
      this.onFavouritesClick,
      this.onPop,
      this.textEditController,
      this.onCancelClick})
      : super(key: key);

  @override
  _TopPanelState createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<Offset> cancelButtonAnimation;
  Animation<Offset> backButtonAnimation;
  Animation<Offset> favButtonAnimation;

  FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(focusListener);

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    cancelButtonAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(animationController);
    backButtonAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(animationController);
    favButtonAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0)).animate(animationController);
    super.initState();
  }

  focusListener() {
    if (focusNode.hasFocus) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  focus() {
    if (!focusNode.hasFocus) focusNode.requestFocus();
  }

  unfocus() {
    if (focusNode.hasFocus) focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var topPanelController = context.watch<TopPanelController>();
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 4, bottom: 4),
        child: Stack(children: [
          topPanelController.needShowBack
              ? Positioned(
                  left: 0,
                  child: SlideTransition(
                      position: backButtonAnimation,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.onPop();
                        },
                        child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            height: 35,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: SVGIcon(
                                icon: IconAsset.back,
                              ),
                            )),
                      )))
              : SizedBox(
                  width: 20,
                ),
          AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final value = animation.value;
                var leftPadding = topPanelController.needShowBack ? 50.0 : 20.0;
                final startPadding = EdgeInsets.only(left: leftPadding, right: 60);
                final endPadding = EdgeInsets.only(left: 20, right: 90);

                return Padding(padding: EdgeInsets.lerp(startPadding, endPadding, value), child: child);
              },
              child: Container(
                height: 35,
                decoration: ShapeDecoration(
                    color: Color(0xFFF6F6F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: TextField(
                      focusNode: focusNode,
                      controller: widget.textEditController,
                      onChanged: (searchQuery) {
                        widget.onSearch(searchQuery);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Поиск",
                      ),
                      style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.normal),
                    )),
                  ],
                ),
              )),
          Positioned(
            right: 0,
            child: SlideTransition(
              position: favButtonAnimation,
              child: GestureDetector(
                onTap: () => {
                  BaseRepository.isAuthorized().then((isAuthorized) {
                    isAuthorized
                        ? widget.onFavouritesClick()
                        : showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            useRootNavigator: true,
                            builder: (context, controller) => AuthorizationSheet());
                  })
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(right: 20),
                  height: 35,
                  alignment: Alignment.center,
                  child: SVGIcon(
                    icon: IconAsset.favoriteBorder,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: SlideTransition(
                position: cancelButtonAnimation,
                child: GestureDetector(
                  onTap: () => {widget.onCancelClick(), unfocus()},
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    height: 35,
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "Отменить",
                      style: textTheme.bodyText2,
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
