import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/product/components/additional_button.dart';

class ProductAdditional extends StatelessWidget {
  final Function(String parameters, String title) onSubCategoryClick;
  final Product product;

  const ProductAdditional({Key key, this.onSubCategoryClick, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProductAdditionalButton(
          text: "Все вещи этого продавца",
          onSubCategoryClick: () {
            onSubCategoryClick("?p=" + product.seller.id, product.seller.name);
          },
        ),
        ProductAdditionalButton(
          text: "Все " + product.brand.name + " бренда " + product.brand.name,
          onSubCategoryClick: () {
            onSubCategoryClick("?p=" + product.brand.id, product.brand.name);
          },
        ),
        ProductAdditionalButton(
          text: "Все " + (product.category != null ? product.category.name : "null"),
          onSubCategoryClick: () {
            onSubCategoryClick("?p=" + product.category.id, product.category.name);
          },
        ),
//        ProductAdditionalButton(
//          text: "Все " + (product.category != null ? product.category.name : "null"),
//          onSubCategoryClick: () {
//            onSubCategoryClick("?p=" + product.category.id, product.category.name);
//          },
//        ),
      ],
    );
  }
}
