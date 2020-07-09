import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';

class CategoryImage extends StatelessWidget {
  final Category category;

  const CategoryImage({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/dresses.png',
          height: 200,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
            child: Container(
          color: Colors.black.withOpacity(0.4),
        )),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(category.name.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.white)),
              SizedBox(
                height: 5,
              ),
              Text("1158 вещей",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white)),
              SizedBox(
                height: 10,
              ),
              Text(
                "Смотреть все товары >",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Color(0xFFFAD24E)),
              )
            ],
          ),
        )
      ],
    );
  }
}
