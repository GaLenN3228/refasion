import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/catalog/components/measure_size.dart';
import 'package:refashioned_app/screens/sell_product/components/tb_button.dart';

class TBSearchController {
  void Function() unfocus;
  void Function() focus;

  TBSearchController() {
    this.unfocus =
        () => print("Search Controller method unfocus wasn't redefined");
    this.focus = () => print("Search Controller method focus wasn't redefined");
  }
}

class TBSearch extends StatefulWidget {
  final TBSearchController searchController;

  final String hintText;
  final Function(String) onSearchUpdate;
  final Function() onFocus;
  final Function() onUnfocus;
  final bool autofocus;

  const TBSearch({
    this.onSearchUpdate,
    this.hintText,
    this.onFocus,
    this.onUnfocus,
    this.autofocus: false,
    this.searchController,
  });

  @override
  _TBSearchState createState() => _TBSearchState(searchController);
}

class _TBSearchState extends State<TBSearch>
    with SingleTickerProviderStateMixin {
  _TBSearchState(TBSearchController searchController) {
    if (searchController != null) {
      searchController.focus = focus;
      searchController.unfocus = unfocus;
    }
  }

  AnimationController animationController;
  Animation<double> animation;
  Animation<Offset> offsetAnimation;
  double buttonWidth;

  FocusNode focusNode;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(animationController);
    buttonWidth = 0;

    focusNode = FocusNode();
    focusNode.addListener(focusListener);

    super.initState();
  }

  focusListener() {
    if (focusNode.hasFocus) {
      animationController.forward();
      if (widget.onFocus != null) widget.onFocus();
    } else {
      animationController.reverse();
      if (widget.onUnfocus != null) widget.onUnfocus();
    }
  }

  focus() {
    if (!focusNode.hasFocus) focusNode.requestFocus();
  }

  unfocus() {
    if (focusNode.hasFocus) focusNode.unfocus();
  }

  @override
  void dispose() {
    focusNode.removeListener(focusListener);
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final value = animation.value;

              final startPadding = const EdgeInsets.fromLTRB(20, 10, 20, 10);
              final endPadding = EdgeInsets.fromLTRB(20, 10, 90, 10);

              return Padding(
                  padding: EdgeInsets.lerp(startPadding, endPadding, value),
                  child: child);
            },
            child: Container(
              height: 35,
              decoration: ShapeDecoration(
                  color: Color(0xFFF6F6F6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                    child: SvgPicture.asset(
                      'assets/small_search.svg',
                      color: Color(0xFF8E8E93),
                      width: 14,
                      height: 14,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: widget.autofocus,
                      enableSuggestions: false,
                      autocorrect: false,
                      focusNode: focusNode,
                      onChanged: widget.onSearchUpdate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText ?? "Поиск",
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: offsetAnimation,
              child: TBButton(
                TBButtonType.text,
                TBButtonAlign.right,
                text: "Отменить",
                onTap: unfocus,
              ),
            ),
          )
        ],
      ),
    );
  }
}
