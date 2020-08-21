import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class TBSearch extends StatefulWidget {
  final TBSearchData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBSearch({Key key, this.data, this.scrollActionsProvider})
      : super(key: key);

  @override
  _TBSearchState createState() => _TBSearchState();
}

class _TBSearchState extends State<TBSearch>
    with SingleTickerProviderStateMixin {
  ValueNotifier<ScrollActionState> stateNotifier;

  AnimationController animationController;
  Animation<double> animation;
  Animation<Offset> offsetAnimation;

  FocusNode focusNode;

  TextEditingController textController;
  ValueNotifier<bool> hasText;

  static final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    stateNotifier = widget.scrollActionsProvider
        ?.getAction(ScrollActionType.elevateTopBar)
        ?.state;
    stateNotifier?.addListener(stateListener);

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

    super.initState();
  }

  focusListener() {
    if (focusNode.hasFocus) {
      animationController.forward();
      if (widget.data.onFocus != null) widget.data.onFocus();
    } else {
      animationController.reverse();
      if (widget.data.onUnfocus != null) widget.data.onUnfocus();
    }
  }

  textListener() {
    final text = textController.text;

    hasText.value = text.isNotEmpty;

    widget.data.onSearchUpdate(text);
  }

  focus() {
    if (!focusNode.hasFocus) focusNode.requestFocus();
  }

  unfocus() {
    if (focusNode.hasFocus) focusNode.unfocus();
  }

  stateListener() {
    switch (stateNotifier?.value) {
      case ScrollActionState.forwarded:
        unfocus();
        break;
      case ScrollActionState.reversed:
        focus();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    stateNotifier?.removeListener(stateListener);

    focusNode.removeListener(focusListener);
    focusNode.dispose();

    textController.removeListener(textListener);
    textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
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
                    child: TextFormField(
                      key: formKey,
                      controller: textController,
                      autofocus: widget.data.autofocus,
                      enableSuggestions: false,
                      autocorrect: false,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.data.hintText ?? "Поиск",
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
                data: TBButtonData(
                  type: TBButtonType.text,
                  align: TBButtonAlign.right,
                  text: "Отменить",
                  onTap: unfocus,
                ),
              ),
            ),
          )
        ],
      );
}
