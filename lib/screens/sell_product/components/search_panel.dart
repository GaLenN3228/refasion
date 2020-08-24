import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: SvgPicture.asset(
                  'assets/small_search.svg',
                  color: Color(0xFF8E8E93),
                  width: 14,
                  height: 14,
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
