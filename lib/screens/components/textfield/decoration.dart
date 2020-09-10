import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/textfield/textfield.dart';

class TBSearchDecoration extends StatefulWidget {
  final bool autofocus;

  final String hintText;

  final FocusNode focusNode;

  final TextEditingController textController;
  final ValueNotifier<bool> hasText;
  final IconAsset icon;

  const TBSearchDecoration({
    Key key,
    this.autofocus,
    this.hintText,
    this.focusNode,
    this.textController,
    this.hasText,
    this.icon,
  }) : super(key: key);

  @override
  _TBSearchDecorationState createState() => _TBSearchDecorationState();
}

class _TBSearchDecorationState extends State<TBSearchDecoration> {
  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        decoration: ShapeDecoration(
            color: Color(0xFFF6F6F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 5, 8),
                    child: SVGIcon(
                      icon: widget.icon,
                      size: 20,
                      color: Color(0xFF8E8E93),
                    ),
                  )
                : SizedBox(
                    width: 10,
                  ),
            Expanded(
              child: TBSearchTextField(
                autofocus: widget.autofocus,
                hintText: widget.hintText,
                focusNode: widget.focusNode,
                textController: widget.textController,
                hasText: widget.hasText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 14,
                height: 14,
                child: ValueListenableBuilder(
                  valueListenable: widget.hasText,
                  builder: (context, value, child) =>
                      value ? child : SizedBox(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => widget.textController.clear(),
                    child: Stack(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.black.withOpacity(0.25)),
                        ),
                        Center(
                          child: SVGIcon(
                            icon: IconAsset.close,
                            size: 10,
                            color: Colors.white,
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
      );
}
