import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TBSearchTextField extends StatefulWidget {
  final bool autofocus;

  final String hintText;

  final FocusNode focusNode;

  final TextEditingController textController;
  final ValueNotifier<bool> hasText;

  final TextInputType keyboardType;

  final MaskTextInputFormatter maskFormatter;

  const TBSearchTextField({
    Key key,
    this.focusNode,
    this.textController,
    this.hasText,
    this.autofocus,
    this.hintText,
    this.keyboardType,
    this.maskFormatter,
  }) : super(key: key);

  @override
  _TBSearchTextFieldState createState() => _TBSearchTextFieldState();
}

class _TBSearchTextFieldState extends State<TBSearchTextField> {
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: TextField(
          inputFormatters: widget.maskFormatter != null ? [widget.maskFormatter] : [],
          controller: widget.textController,
          autofocus: widget.autofocus,
          enableSuggestions: false,
          autocorrect: false,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText ?? "Поиск",
              hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(0, 0, 0, 0.25))),
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.normal),
        ),
      );
}
