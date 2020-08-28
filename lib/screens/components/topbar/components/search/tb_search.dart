import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/search/decoration.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class TBSearch extends StatefulWidget {
  final TBSearchData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  final bool showCancelButton;

  const TBSearch(
      {Key key,
      this.data,
      this.scrollActionsProvider,
      this.showCancelButton: false})
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
    print("focus textfield");

    if (!focusNode.hasFocus) focusNode.requestFocus();
  }

  unfocus() {
    print("unfocus textfield");
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
  Widget build(BuildContext context) {
    if (widget.data == null) return SizedBox();

    if (!widget.showCancelButton)
      return TBSearchDecoration(
        autofocus: widget.data.autofocus,
        hintText: widget.data.hintText,
        focusNode: focusNode,
        textController: textController,
        hasText: hasText,
      );

    return Stack(
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
          child: TBSearchDecoration(
            autofocus: widget.data.autofocus,
            hintText: widget.data.hintText,
            focusNode: focusNode,
            textController: textController,
            hasText: hasText,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: offsetAnimation,
            child: TBButton(
              padding: EdgeInsets.only(left: 10, right: 20),
              data: TBButtonData(
                label: "Отменить",
                onTap: unfocus,
              ),
            ),
          ),
        )
      ],
    );
  }
}
