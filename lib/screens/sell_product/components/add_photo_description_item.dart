import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddPhotoDescriptionItem extends StatelessWidget {
  final String title;

  const AddPhotoDescriptionItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Row(children: [
          SvgPicture.asset(
            'assets/check_yellow.svg',
            width: 14,
            height: 14,
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: textTheme.subtitle1,
                  maxLines: 2,
                )),
          )
        ]));
  }
}
