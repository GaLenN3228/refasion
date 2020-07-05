import 'package:flutter/material.dart';

class ProductQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              title: Text("Вопросы о товаре"),
              subtitle: Text(
                "Задайте вопрос и вам ответят",
                style: TextStyle(color: const Color(0xFF959595)),
              ),
              trailing: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                color: Colors.amber,
                onPressed: () {},
                child: Text("СПРОСИТЬ"),
              )),
          Container(
            color: const Color(0xFFE6E6E6),
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 1,
          ),
          ListTile(
              isThreeLine: false,
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              title: Row(
                children: <Widget>[
                  Text("Все вопросы "),
                  Text("3", style: TextStyle(color: const Color(0xFF959595))),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right))
        ],
      ),
    );
  }
}
