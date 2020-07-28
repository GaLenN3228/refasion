import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/product/components/add_to_cart.dart';
import 'package:refashioned_app/screens/product/components/additional.dart';
import 'package:refashioned_app/screens/product/components/delivery.dart';
import 'package:refashioned_app/screens/product/components/description.dart';
import 'package:refashioned_app/screens/product/components/payment.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/product/components/questions.dart';
import 'package:refashioned_app/screens/product/components/recommended.dart';
import 'package:refashioned_app/screens/product/components/related_products.dart';
import 'package:refashioned_app/screens/product/components/seller.dart';
import 'package:refashioned_app/screens/product/components/slider.dart';
import 'package:refashioned_app/screens/product/components/title.dart';

class ProductPageContent extends StatefulWidget {
  @override
  _ProductPageContentState createState() => _ProductPageContentState();
}

class _ProductPageContentState extends State<ProductPageContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final ProductRepository productRepository = context.watch<ProductRepository>();
    if (productRepository.isLoading)
      return Center(
        child: Text("Загрузка"),
      );

    if (productRepository.loadingFailed)
      return Center(
        child: Text("Ошибка"),
      );

    if (productRepository.productResponse.status.code != 200)
      return Center(
        child: Text("Иной статус"),
      );

    final Product product = productRepository.productResponse.product;

    return ListView(
      children: <Widget>[
        ProductSlider(
          images: product.images,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              ProductPrice(
                currentPrice: product.currentPrice,
                discountPrice: product.discountPrice,
              ),
              ProductTitle(
                name: product.name,
                brand: product.brand.name,
              ),
              ProductAddToCart(),
              ProductSeller(),
              ProductDescription(
                description: product.description,
                properties: product.properties,
                article: product.article,
              ),
              ProductQuestions(),
              ProductDelivery(),
              ProductPayment(),
              ProductAdditional(),
              RelatedProducts(),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ВАМ МОЖЕТ ПОНРАВИТЬСЯ",
                      style: textTheme.headline2,
                    ),
                  ),
                  ChangeNotifierProvider<ProductsRepository>(
                      create: (_) => ProductsRepository(parameters: "?p=93d38e10-fa55-417f-9fe0-493e55de5a17"),
                      builder: (context, _) {
                        return RecommendedProducts();
                      }
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}