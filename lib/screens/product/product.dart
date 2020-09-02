import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/products.dart';
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
  final Function(String parameters, String title) onSubCategoryClick;

  const ProductPage({this.product, this.onProductPush, this.onSellerPush, this.onSubCategoryClick})
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

    productRepository = ProductRepository();
    productRepository.getProduct(widget.product.id);

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
                childrenData: ScaffoldChildrenData.message("Ошибка при загрузке товара"),
                onBack: () => Navigator.of(context).pop(),
                bottomOverlay: ProductBottomButtons(),
              ),
          Status.loading: () => ScaffoldData.simple(
                childrenData: ScaffoldChildrenData.message("Загружаем товар..."),
                onBack: () => Navigator.of(context).pop(),
                bottomOverlay: ProductBottomButtons(),
              ),
          Status.loaded: () {
            final product = productRepository.response.content;

            return ScaffoldData(
              topBarData: TopBarData(
                leftButtonData: TBButtonData.icon(
                  TBIconType.back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                middleData: TBMiddleData.condensed(
                  product.brand.name.toString() + " • " + product.name.toString(),
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
                        ProductAdditional(
                          product: product,
                          onSubCategoryClick: widget.onSubCategoryClick,
                        ),
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
                            ChangeNotifierProvider<ProductRecommendedRepository>(
                              create: (_) => ProductRecommendedRepository()..getProductRecommended(product.id),
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
//              Positioned(
//                left: 0,
//                top: 0,
//                right: 0,
//                child: MeasureSize(
//                  onChange: (size, position) => sizesRepository.update(WidgetKeys.topBar, size, position),
//                  child:
//                      Consumer<AddRemoveFavouriteRepository>(builder: (context, addRemoveFavouriteRepository, child) {
//                    return RefashionedTopBar(
//                        leftButtonType: TBButtonType.icon,
//                        leftButtonIcon: TBIconType.back,
//                        leftButtonAction: () => Navigator.of(context).pop(),
//                        middleType: TBMiddleType.condensed,
//                        middleTitleText: product.brand.name + " • " + product.name,
//                        middleSubtitleText: product.currentPrice.toString() + " ₽",
//                        rightButtonType: TBButtonType.icon,
//                        rightButtonIcon:
//                            product.isFavourite ? TBIconType.favorites_checked : TBIconType.favorites_unchecked,
//                        rightButtonAction: () {
//                          BaseRepository.isAuthorized().then((isAuthorized) {
//                            isAuthorized
//                                ? product.isFavourite
//                                    ? addRemoveFavouriteRepository
//                                        .removeFromFavourites((product..isFavourite = false).id)
//                                    : addRemoveFavouriteRepository
//                                        .addToFavourites((product..isFavourite = true).id)
//                                : showCupertinoModalBottomSheet(
//                                    backgroundColor: Colors.white,
//                                    expand: false,
//                                    context: context,
//                                    useRootNavigator: true,
//                                    builder: (context, controller) => ProfilePage());
//                          });
//                        },
//                        secondRightButtonType: TBButtonType.icon,
//                        secondRightButtonIcon: TBIconType.share,
//                        scrollController: scrollController,
//                        scrollPastOffset: productPageTitleBottomScrollOffset);
//                  }),
//                ),
//              ),
//              Positioned(
//                left: 0,
//                right: 0,
//                bottom: bottomNavigationTopOffsetFromBottom,
//                child: MeasureSize(
//                    onChange: (size, position) => sizesRepository.update(
//                        WidgetKeys.productPageButtons, size, position),
//                    child: ProductBottomButtons(
//                      productId: product.id,
//                    )),
//              ),
//            ],
//          ),
//        );
//      },
//    );
//  }
}
