import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/utils/colors.dart';

final basePath = "assets/images/svg/";

enum ImageAsset {
  refashionedLogo,
  catalogBrandsBackground,
}

final assets = {
  ImageAsset.refashionedLogo: "refashioned_logo.svg",
  ImageAsset.catalogBrandsBackground: "catalog_brands_background.svg",
};

class SVGImage extends StatelessWidget {
  final ImageAsset image;
  final double width;
  final double height;
  final Color color;

  const SVGImage({this.image, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    if (image == null)
      return SizedBox(
        width: width,
        height: height,
      );

    return SvgPicture.asset(
      basePath + assets[image],
      width: width,
      height: height,
      color: color ?? primaryColor,
    );
  }
}
