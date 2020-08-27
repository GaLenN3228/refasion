import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/components/search/textfield.dart';

class TBSearchDecoration extends StatelessWidget {
  final bool autofocus;

  final String hintText;

  final FocusNode focusNode;

  final TextEditingController textController;
  final ValueNotifier<bool> hasText;

  const TBSearchDecoration(
      {Key key,
      this.autofocus,
      this.hintText,
      this.focusNode,
      this.textController,
      this.hasText})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 35,
        decoration: ShapeDecoration(
            color: Color(0xFFF6F6F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 5, 8),
              child: SVGIcon(
                icon: IconAsset.search,
                size: 20,
                color: Color(0xFF8E8E93),
              ),
            ),
            Expanded(
              child: TBSearchTextField(
                autofocus: autofocus,
                hintText: hintText,
                focusNode: focusNode,
                textController: textController,
                hasText: hasText,
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
