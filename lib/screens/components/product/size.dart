import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/sizes_table_link.dart';
import 'package:refashioned_app/screens/components/webview_page.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ProductSizeTileStyle { small, large }

class ProductSizeTile extends StatelessWidget {
  final Product product;
  final ProductSizeTileStyle style;
  final Function(String url, String title) openInfoWebViewBottomSheet;

  final EdgeInsets padding;

  const ProductSizeTile({
    this.product,
    this.style: ProductSizeTileStyle.small,
    this.padding,
    this.openInfoWebViewBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final size =
        product.sizes.firstWhere((element) => element.shortCode == 'RU', orElse: () => null);

    if (size == null) return SizedBox();

    switch (style) {
      case ProductSizeTileStyle.large:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Размер: ${size.value} ${size.shortCode}" +
                    (size.secondaryValue != null ? " (${size.secondaryValue})" : ""),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizesTableLink(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                          child: WebViewPage(
                            initialUrl: "https://refashioned.ru/size",
                            title: "ТАБЛИЦА РАЗМЕРОВ",
                            webViewPageMode: WebViewPageMode.modalSheet,
                          ))));
                },
              ),
            ],
          ),
        );

      default:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: RichText(
            text: TextSpan(
              text: "Размер: ",
              children: [
                TextSpan(
                  text: size.value,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: primaryColor,
                        height: 1.0,
                      ),
                ),
              ],
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    height: 1.0,
                  ),
            ),
          ),
        );
    }
  }
}
