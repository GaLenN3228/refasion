import 'package:flutter/material.dart';

class TBSearchTextField extends StatefulWidget {
  final bool autofocus;

  final String hintText;

  final FocusNode focusNode;

  final TextEditingController textController;
  final ValueNotifier<bool> hasText;

  const TBSearchTextField({
    Key key,
    this.focusNode,
    this.textController,
    this.hasText,
    this.autofocus,
    this.hintText,
  }) : super(key: key);

  @override
  _TBSearchTextFieldState createState() => _TBSearchTextFieldState();
}

class _TBSearchTextFieldState extends State<TBSearchTextField> {
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: TextField(
          controller: widget.textController,
          autofocus: widget.autofocus,
          enableSuggestions: false,
          autocorrect: false,
          focusNode: widget.focusNode,
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
