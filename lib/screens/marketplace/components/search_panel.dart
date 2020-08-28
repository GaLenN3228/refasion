import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class SearchPanel extends StatelessWidget {
  final String initialQuery;

  final Function(String) onUpdate;
  final FocusNode focusNode;

  const SearchPanel({Key key, this.onUpdate, this.focusNode, this.initialQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 13, 20, 4),
      child: Material(
        color: Colors.white,
        child: Container(
          height: 35,
          decoration: ShapeDecoration(
              color: Color(0xFFF6F6F6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Row(
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
                  child: TextField(
                controller: TextEditingController(text: initialQuery),
                autofocus: true,
                autocorrect: false,
                focusNode: focusNode ?? FocusNode(),
                onChanged: (query) => onUpdate(query),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Поиск",
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.normal),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
