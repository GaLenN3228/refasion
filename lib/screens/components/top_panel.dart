import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PanelType { search, item }

class TopPanel extends StatelessWidget {
  final bool canPop;
  final Function() onPop;
  final PanelType type;

  const TopPanel(
      {Key key, this.canPop: false, this.onPop, this.type: PanelType.search})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: [
              SizedBox(
                width: 4,
              ),
              canPop && onPop != null
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => onPop(),
                      child: SvgPicture.asset(
                        "assets/back.svg",
                        color: Color(0xFF222222),
                        width: 44,
                      ),
                    )
                  : SizedBox(
                      width: 16,
                    ),
              Expanded(
                child: type == PanelType.search
                    ? Container(
                        height: 35,
                        decoration: ShapeDecoration(
                            color: Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: SvgPicture.asset(
                                'assets/small_search.svg',
                                color: Color(0xFF8E8E93),
                                width: 14,
                                height: 14,
                              ),
                            ),
                            Text(
                              "Поиск",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black.withOpacity(0.25)),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
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
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
