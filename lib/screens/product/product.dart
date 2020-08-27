import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/product.dart';
import 'package:refashioned_app/repositories/product_recommended.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/scaffold.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/product/components/additional.dart';
import 'package:refashioned_app/screens/product/components/buttons.dart';
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

class ProductPage extends StatefulWidget {
  final Product product;

  final Function(Product) onProductPush;
  final Function(Seller) onSellerPush;

  const ProductPage({this.product, this.onProductPush, this.onSellerPush})
      : assert(product != null);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  WidgetData productTitleWidgetData;

  ProductRepository productRepository;

  @override
  void initState() {
    productTitleWidgetData = WidgetData.create("productTitle");

    productRepository = ProductRepository(widget.product.id);

    super.initState();
  }

  @override
  void dispose() {
    productRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefashionedScaffold(
        state: productRepository.statusNotifier,
        stateData: {
          Status.error: () => ScaffoldData.simple(
                childrenData:
                    ScaffoldChildrenData.message("Ошибка при загрузке товара"),
                onBack: () => Navigator.of(context).pop(),
                bottomOverlay: ProductBottomButtons(),
              ),
          Status.loading: () => ScaffoldData.simple(
                childrenData:
                    ScaffoldChildrenData.message("Загружаем товар..."),
                onBack: () => Navigator.of(context).pop(),
                bottomOverlay: ProductBottomButtons(),
              ),
          Status.loaded: () {
            final product = productRepository.productResponse.product;

            return ScaffoldData(
              topBarData: TopBarData(
                leftButtonData: TBButtonData.icon(
                  TBIconType.back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                middleData: TBMiddleData.condensed(
                  product.brand.name.toString() +
                      " • " +
                      product.name.toString(),
                  product.currentPrice.toString() + " ₽",
                ),
                secondRightButtonData: TBButtonData(
                  iconType: TBIconType.favorites,
                ),
                rightButtonData: TBButtonData(
                  iconType: TBIconType.share,
                ),
              ),
              bottomOverlay: ProductBottomButtons(
                productId: product.id,
              ),
              scrollActions: {
                productTitleWidgetData: ScaffoldScrollAction(
                  type: ScrollActionType.fadeTopBarMiddle,
                ),
              },
              childrenData: ScaffoldChildrenData(
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
                        SizedBox(
                          key: productTitleWidgetData.key,
                          child: ProductTitle(
                            name: product.name,
                            brand: product.brand.name,
                          ),
                        ),
                        ProductSeller(
                          seller: product.seller,
                        ),
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
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                            ChangeNotifierProvider<
                                ProductRecommendedRepository>(
                              create: (_) =>
                                  ProductRecommendedRepository(product.id),
                              child: RecommendedProducts(
                                onProductPush: widget.onProductPush,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        },
      );
}
