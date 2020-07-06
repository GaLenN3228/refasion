import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

final List<String> imgList = [
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg',
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg',
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg',
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg',
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg',
  'https://docs.refashioned.ru/media/product/89e8bf1f-dd00-446c-8bce-4a5e9a31586a/b9fa34e18edb4970d8e115df172c0512.jpg'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Image.network(item, fit: BoxFit.contain),
          ),
        ))
    .toList();

class ProductSlider extends StatefulWidget {
  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
                height: 300.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: imageSliders,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList
                .asMap()
                .map((index, value) => MapEntry(
                    index,
                    Container(
                      width: 7.0,
                      height: 7.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? accentColor : lightGrayColor,
                      ),
                    )))
                .values
                .toList(),
          ),
        ],
      ),
    );
  }
}
