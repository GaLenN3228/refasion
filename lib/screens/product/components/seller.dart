import 'package:flutter/material.dart';

class ProductSeller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.5)),
      ),
      child: ListTile(
        isThreeLine: false,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage(
                'assets/seller.png',
              ),
            ),
          ),
        ),
        title: Text("Продавец"),
        subtitle: Text("Камила"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //TODO: Поменять иконку с UI
                for (int i = 0; i < 4; i++)
                  Icon(Icons.star, size: 10, color: const Color(0xFFFAD24E)),
                Icon(Icons.star_half, size: 10, color: const Color(0xFFFAD24E)),
                Text(
                  "4.2",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                )
              ],
            ),
            Text(
              "7 отзывов",
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
