import 'package:flutter/material.dart';
import 'package:refashioned_app/components/button.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart.dart';
import 'package:refashioned_app/screens/product/components/additional.dart';
import 'package:refashioned_app/screens/product/components/delivery.dart';
import 'package:refashioned_app/screens/product/components/description.dart';
import 'package:refashioned_app/screens/product/components/payment.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/product/components/questions.dart';
import 'package:refashioned_app/screens/product/components/related_products.dart';
import 'package:refashioned_app/screens/product/components/seller.dart';
import 'package:refashioned_app/screens/product/components/slider.dart';
import 'package:refashioned_app/screens/product/components/title.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPage extends StatelessWidget {
  final Function() onPop;

  const ProductPage({Key key, this.onPop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopPanel(
          canPop: true,
          onPop: onPop,
          type: PanelType.item,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              ProductSlider(),
              ProductPrice(),
              ProductTitle(),
              ProductAddToCart(),
              ProductSeller(),
              ProductDescription(),
              ProductQuestions(),
              ProductDelivery(),
              ProductPayment(),
              ProductAdditional(),
              RelatedProducts(),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: lightGrayColor, width: 0)),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: double.infinity,
                        child:
                            Button("Проверка", buttonStyle: ButtonStyle.dark)),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                        height: double.infinity,
                        child: Button("В корзину",
                            buttonStyle: ButtonStyle.amber)),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
