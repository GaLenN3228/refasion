import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductSlider extends StatefulWidget {
  final List<String> images;

  const ProductSlider({Key key, this.images}) : super(key: key);

  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  int _current = 0;

  _getImagesSlider() => widget.images
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Image.network(item, fit: BoxFit.contain),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    if (widget.images == null) return SizedBox();

    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 300.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: _getImagesSlider(),
          ),
          widget.images.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images
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
                )
              : SizedBox(height: 27),
        ],
      ),
    );
  }
}
