import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/sizes.dart';
import 'package:refashioned_app/screens/catalog/components/measure_size.dart';
import 'package:refashioned_app/screens/components/empty_page.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
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
  ProductRepository productRepository;

  SizesRepository sizesRepository;

  ScrollController scrollController;

  @override
  void initState() {
    productRepository = ProductRepository();
    productRepository.addListener(repositoryListener);
    productRepository.getProduct(widget.product.id);

    sizesRepository = Provider.of<SizesRepository>(context, listen: false);

    scrollController = ScrollController();

    super.initState();
  }

  repositoryListener() => setState(() {});

  @override
  void dispose() {
    scrollController.dispose();

    productRepository.removeListener(repositoryListener);

    productRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (productRepository.isLoading)
      return EmptyPage(text: "Загружаем товар...");

    if (productRepository.loadingFailed)
      return EmptyPage(text: "Ошибка при загрузке товара");

    final product = productRepository.response.content;

    return StreamBuilder<Map<WidgetKeys, WidgetData>>(
      stream: sizesRepository.data,
      builder: (context, sizesSnapshot) {
        if (!sizesSnapshot.hasData) return EmptyPage(text: "Нет размеров");

        if (sizesSnapshot.hasError)
          return EmptyPage(
              text: "Ошибка размеров: " + sizesSnapshot.error.toString());

        final data = sizesSnapshot.data;

        final screenHeight = MediaQuery.of(context).size.height;

        final productPageTitleData =
            data[WidgetKeys.productPageTitle] ?? WidgetData();

        final topBarData = data[WidgetKeys.topBar] ?? WidgetData();

        final productPageButtonsData =
            data[WidgetKeys.productPageButtons] ?? WidgetData();

        final bottomNavigationData =
            data[WidgetKeys.bottomNavigation] ?? WidgetData();

        final productPageTitleTopOffset = productPageTitleData.position.dy;
        final topBarBottomOffset =
            topBarData.position.dy + topBarData.size.height;

        final productPageTitleBottomScrollOffset = productPageTitleTopOffset -
            topBarBottomOffset +
            productPageTitleData.size.height / 2;

        final bottomNavigationTopOffsetFromBottom =
            screenHeight - bottomNavigationData.position.dy;

        final buttonsTopOffsetFromBottom =
            screenHeight - productPageButtonsData.position.dy;

        return CupertinoPageScaffold(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Material(
                color: Colors.white,
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                      top: topBarBottomOffset,
                      bottom: buttonsTopOffsetFromBottom),
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
                          MeasureSize(
                            onChange: (size, position) =>
                                sizesRepository.update(
                                    WidgetKeys.productPageTitle,
                                    size,
                                    position),
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
                                    ProductRecommendedRepository()..getProductRecommended(product.id),
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
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: MeasureSize(
                  onChange: (size, position) =>
                      sizesRepository.update(WidgetKeys.topBar, size, position),
                  child: RefashionedTopBar(
                      leftButtonType: TBButtonType.icon,
                      leftButtonIcon: TBIconType.back,
                      leftButtonAction: () => Navigator.of(context).pop(),
                      middleType: TBMiddleType.condensed,
                      middleTitleText:
                          product.brand.name + " • " + product.name,
                      middleSubtitleText:
                          product.currentPrice.toString() + " ₽",
                      rightButtonType: TBButtonType.icon,
                      rightButtonIcon: TBIconType.favorites,
                      secondRightButtonType: TBButtonType.icon,
                      secondRightButtonIcon: TBIconType.share,
                      scrollController: scrollController,
                      scrollPastOffset: productPageTitleBottomScrollOffset),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomNavigationTopOffsetFromBottom,
                child: MeasureSize(
                    onChange: (size, position) => sizesRepository.update(
                        WidgetKeys.productPageButtons, size, position),
                    child: ProductBottomButtons(
                      productId: product.id,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
