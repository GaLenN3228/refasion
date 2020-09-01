import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

class SearchButton extends StatelessWidget {
  final Function onSearchButtonClick;

  const SearchButton({Key key, this.onSearchButtonClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => {onSearchButtonClick()},
            child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(left: 14, right: 18),
                height: 50,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SVGIcon(
                      icon: IconAsset.search,
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        "Искать по адресу",
                        style: TextStyle(
                            fontSize: 12, fontFamily: "SF UI Text", fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                    )
                  ],
                ))));
  }
}
