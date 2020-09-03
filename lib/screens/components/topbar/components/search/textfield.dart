import 'package:flutter/material.dart';

class TBSearchTextField extends StatelessWidget {
  final bool autofocus;

  final String hintText;

  final FocusNode focusNode;

  final TextEditingController textController;
  final ValueNotifier<bool> hasText;

  static final _formKey = GlobalKey<FormState>();

  const TBSearchTextField(
      {Key key,
      this.focusNode,
      this.textController,
      this.hasText,
      this.autofocus,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: TextField(
            controller: textController,
            autofocus: autofocus,
            enableSuggestions: false,
            autocorrect: false,
            focusNode: focusNode,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText ?? "Поиск",
                hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Color.fromRGBO(0, 0, 0, 0.25))),
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      );
}
