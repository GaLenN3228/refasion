import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/textfield/decoration.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';

class RefashionedTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchUpdate;
  final Function() onCancel;

  final bool autofocus;
  final IconAsset icon;

  final GlobalKey<FormState> formKey;

  const RefashionedTextField(
      {Key key,
      this.onCancel,
      this.hintText,
      this.onSearchUpdate,
      this.autofocus: false,
      this.icon,
      this.formKey})
      : super(key: key);

  factory RefashionedTextField.fromTbSearchData(TBSearchData data) =>
      RefashionedTextField(
        autofocus: data.autofocus,
        hintText: data.hintText,
        onSearchUpdate: data.onSearchUpdate,
        onCancel: () {},
        icon: IconAsset.search,
      );

  @override
  _RefashionedTextFieldState createState() => _RefashionedTextFieldState();
}

class _RefashionedTextFieldState extends State<RefashionedTextField>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<Offset> offsetAnimation;

  FocusNode focusNode;

  TextEditingController textController;
  ValueNotifier<bool> hasText;

  @override
  void initState() {
    if (widget.onCancel != null) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
      animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
      offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(animationController);

      focusNode = FocusNode();
      focusNode.addListener(focusListener);
    }

    textController = TextEditingController();
    textController.addListener(textListener);

    hasText = ValueNotifier(false);

    super.initState();
  }

  focusListener() {
    if (focusNode.hasFocus)
      animationController.forward();
    else
      animationController.reverse();
  }

  textListener() {
    final text = textController.text;
    hasText.value = text.isNotEmpty;
    if (widget.onSearchUpdate != null) widget.onSearchUpdate(text);
  }

  @override
  void dispose() {
    animationController?.dispose();

    focusNode?.removeListener(focusListener);
    focusNode?.dispose();

    textController.removeListener(textListener);
    textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onCancel == null)
      return TBSearchDecoration(
        autofocus: widget.autofocus,
        hintText: widget.hintText,
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
            icon: widget.icon,
            autofocus: widget.autofocus,
            hintText: widget.hintText,
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
                onTap: () {
                  focusNode.unfocus();
                  widget.onCancel();
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
