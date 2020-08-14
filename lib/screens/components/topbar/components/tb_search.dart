import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';

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

  final ValueNotifier<bool> isScrolled;

  const TBSearch({
    this.onSearchUpdate,
    this.hintText,
    this.onFocus,
    this.onUnfocus,
    this.autofocus: false,
    this.searchController,
    this.isScrolled,
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

  FocusNode focusNode;

  TextEditingController textController;
  ValueNotifier<bool> hasText;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(animationController);

    focusNode = FocusNode();
    focusNode.addListener(focusListener);

    textController = TextEditingController();
    textController.addListener(textListener);

    hasText = ValueNotifier(false);

    widget.isScrolled?.addListener(scrollListener);

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

  textListener() {
    final text = textController.text;

    hasText.value = text.isNotEmpty;

    widget.onSearchUpdate(text);
  }

  scrollListener() {
    if (widget.isScrolled.value)
      unfocus();
    else
      focus();
  }

  @override
  void dispose() {
    widget.isScrolled?.removeListener(scrollListener);

    focusNode.removeListener(focusListener);
    focusNode.dispose();

    textController.removeListener(textListener);
    textController.dispose();

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
                      'assets/topbar/svg/search_14dp.svg',
                      color: Color(0xFF8E8E93),
                      width: 14,
                      height: 14,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      autofocus: widget.autofocus,
                      enableSuggestions: false,
                      autocorrect: false,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText ?? "Поиск",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(0, 0, 0, 0.25))),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: ValueListenableBuilder(
                        valueListenable: hasText,
                        builder: (context, value, child) =>
                            value ? child : SizedBox(),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => textController.clear(),
                          child: Stack(
                            children: [
                              Container(
                                decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.black.withOpacity(0.25)),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/topbar/svg/close_14dp.svg',
                                  color: Colors.white,
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
