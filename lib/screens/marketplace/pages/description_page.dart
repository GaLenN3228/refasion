import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class DescriptionPage extends StatefulWidget {
  final String initialData;

  final Function() onClose;
  final Function(String) onUpdate;
  final Function() onPush;

  final FocusNode focusNode;

  const DescriptionPage(
      {Key key,
      this.onPush,
      this.onClose,
      this.focusNode,
      this.onUpdate,
      this.initialData})
      : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage>
    with WidgetsBindingObserver {
  final double bottomPadding = 16;

  TextEditingController textEditingController;
  bool canPush;
  bool keyboardVisible;

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.initialData);
    canPush = false;
    keyboardVisible = false;

    textEditingController.addListener(textControllerListener);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  textControllerListener() {
    final newtext = textEditingController.text;
    widget.onUpdate(newtext);

    if (newtext.isNotEmpty != canPush)
      setState(() => canPush = newtext.isNotEmpty);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textControllerListener);

    textEditingController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //Метод определения высоты клавиатуры: https://medium.com/flutter-nyc/avoiding-the-on-screen-keyboard-in-flutter-ae0e46ecb96c

  // @override
  // void didChangeMetrics() {
  //   final renderObject = context.findRenderObject();
  //   final renderBox = renderObject as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   final widgetRect = Rect.fromLTWH(
  //     offset.dx,
  //     offset.dy,
  //     renderBox.size.width,
  //     renderBox.size.height,
  //   );
  //   final keyboardTopPixels =
  //       window.physicalSize.height - window.viewInsets.bottom;
  //   final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
  //   final overlap = widgetRect.bottom - keyboardTopPoints;
  //   print("Overlap: " + overlap.toString());

  //   if (overlap > 200) {
  //     setState(() => bottomOverlap = overlap + bottomPadding);
  //     print("Bottom Overlap: " + bottomOverlap.toString() + "\n\n");
  //   } else if (overlap == 0) {
  //     setState(() => bottomOverlap = 0);
  //     print("Bottom Overlap: " + bottomOverlap.toString() + "\n\n");
  //   }
  // }

  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;

    setState(() {
      keyboardVisible = overlap > 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: () => Navigator.of(context).pop(),
              middleText: "Добавить вещь",
              onClose: widget.onClose,
              bottomText: "Опишите вещь",
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: TextField(
                  controller: textEditingController,
                  expands: true,
                  maxLines: null,
                  autofocus: true,
                  focusNode: widget.focusNode,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontWeight: FontWeight.normal),
                  cursorWidth: 2.0,
                  cursorRadius: Radius.circular(2.0),
                  cursorColor: Color(0xFFE6E6E6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Опишите вашу вещь",
                    hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
          BottomButton(
            title: "Продолжить".toUpperCase(),
            enabled: canPush,
            action: () => widget.onPush(),
          ),
          AnimatedContainer(
            height: keyboardVisible ? bottomPadding : 0,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
