import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
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
                  Text(
                    "Поиск",
                    style: TextStyle(
                        fontFamily: "SF UI",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.25)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, right: 8),
          child: SvgPicture.asset(
            'assets/favorite_border.svg',
            color: Colors.black,
            width: 44,
            height: 44,
          ),
        )
      ],
    );
  }
}
