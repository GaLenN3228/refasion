import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/cart/cart/components/brand.dart';
import 'package:refashioned_app/screens/cart/cart/components/price.dart';
import 'package:refashioned_app/screens/cart/cart/components/size.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';

class CartProduct extends StatelessWidget {
  final Product product;
  final Function() onProductPush;

  const CartProduct({this.product, this.onProductPush});

  final bool colored = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onProductPush ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          color: colored ? Colors.cyanAccent : null,
          child: Row(
            children: [
              Container(
                color: colored ? Colors.pinkAccent : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: RefashionedCheckbox(),
                ),
              ),
              Container(
                color: colored ? Colors.deepPurpleAccent : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image != null
                          ? product.image
                          : "https://admin.refashioned.ru/media/product/2c8cb353-4feb-427d-9279-d2b75f46d786/2b22b56279182fe9bedb1f246d9b44b7.JPG",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: colored ? Colors.deepOrangeAccent : null,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: colored ? Colors.lightBlueAccent : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ProductPrice(product),
                        ProductBrand(product),
                        ProductSize(product),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: colored ? Colors.amberAccent : null,
                child: SVGIcon(
                  icon: IconAsset.more,
                  size: 24,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
