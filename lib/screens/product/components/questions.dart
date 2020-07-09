import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 35, bottom: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xffF5F5F5),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            isThreeLine: false,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            title: Text("Вопросы о товаре", style: textTheme.headline2),
            subtitle: Text(
              "Задайте вопрос и вам ответят",
              style: textTheme.bodyText2,
            ),
            trailing: Button("Спросить", buttonStyle: ButtonStyle.amber,),
          ),
          Container(
            color: const Color(0xFFE6E6E6),
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 1,
          ),
          ListTile(
              isThreeLine: false,
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              title: Row(
                children: <Widget>[
                  Text("Все вопросы  ", style: textTheme.subtitle1,),
                  Text("3", style: textTheme.bodyText2),
                ],
              ),
              trailing: SvgPicture.asset(
                'assets/arrow_right.svg',
                height: 12,
                color: primaryColor,
              ),)
        ],
      ),
    );
  }
}
