import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:refashioned_app/utils/url.dart';

class ProductSlider extends StatefulWidget {
  final List<String> images;

  const ProductSlider({Key key, this.images}) : super(key: key);

  @override
  _ProductSliderState createState() {
    return _ProductSliderState(images);
  }
}

class _ProductSliderState extends State<ProductSlider> {
  int _current = 0;
  final List<String> images;

  _getImagesSlider() => images
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Image.network(Url.mediaBaseUrl + item, fit: BoxFit.contain),
            ),
          ))
      .toList();

  _ProductSliderState(this.images);

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
            items: _getImagesSlider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images
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
