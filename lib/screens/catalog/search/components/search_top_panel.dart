import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchTopPanel extends StatelessWidget {
  final Function(String) onUpdate;

  const SearchTopPanel({Key key, this.onUpdate}) : super(key: key);

  search(String query) {
    onUpdate(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 35,
              decoration: ShapeDecoration(
                  color: Color(0xFFF6F6F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
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
                    autofocus: true,
                    autocorrect: false,
                    focusNode: FocusScopeNode(),
                    onChanged: (query) => search(query),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Поиск",
                    ),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.normal),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              "Отменить",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
