import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/product/components/additional.dart';
import 'package:refashioned_app/screens/product/components/buttons.dart';
import 'package:refashioned_app/screens/product/components/delivery.dart';
import 'package:refashioned_app/screens/product/components/description.dart';
import 'package:refashioned_app/screens/product/components/price.dart';
import 'package:refashioned_app/screens/product/components/recommended.dart';
import 'package:refashioned_app/screens/product/components/seller.dart';
import 'package:refashioned_app/screens/product/components/slider.dart';
import 'package:refashioned_app/screens/product/components/title.dart';
import 'package:refashioned_app/screens/profile/profile.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  final Function(Product) onProductPush;
  final Function(Seller) onSellerPush;
  final Function(String parameters, String title) onSubCategoryClick;
  final Function() onCartPush;

  final Function(String deliveryCompanyId, String deliveryObjectId)
      onCheckoutPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  const ProductPage({
    this.product,
    this.onProductPush,
    this.onSellerPush,
    this.onSubCategoryClick,
    this.onCartPush,
    this.openDeliveryTypesSelector,
    this.onCheckoutPush,
  }) : assert(product != null);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductRepository productRepository;

  Status status;

  @override
  void initState() {
    status = Status.LOADING;

    productRepository = ProductRepository();
    productRepository.getProduct(widget.product.id);

    productRepository.statusNotifier.addListener(repositoryStatusListener);

    super.initState();
  }

  repositoryStatusListener() =>
      setState(() => status = productRepository.statusNotifier.value);

  @override
  void dispose() {
    productRepository.statusNotifier.removeListener(repositoryStatusListener);

    productRepository.dispose();

    super.dispose();
  }

  Widget updateTopBar(Status status) {
    switch (status) {
      case Status.LOADED:
        final product = productRepository.response.content;

        if (product == null)
          return RefashionedTopBar(
            data: TopBarData(
              leftButtonData: TBButtonData.icon(
                TBIconType.back,
                onTap: Navigator.of(context).pop,
              ),
            ),
          );

        return Builder(
          builder: (context) {
            final isFavorite = true;

            return Consumer<AddRemoveFavouriteRepository>(
                builder: (context, addRemoveFavouriteRepository, child) {
              return RefashionedTopBar(
                data: TopBarData(
                  leftButtonData: TBButtonData.icon(
                    TBIconType.back,
                    onTap: Navigator.of(context).pop,
                  ),
                  middleData: TBMiddleData.condensed(
                    product.brand.name.toString() +
                        " • " +
                        product.name.toString(),
                    product.currentPrice.toString() + " ₽",
                  ),
                  secondRightButtonData: isFavorite
                      ? TBButtonData(
                          iconType: widget.product.isFavourite
                              ? TBIconType.favoriteFilled
                              : TBIconType.favorite,
                          iconColor: widget.product.isFavourite
                              ? Color(0xFFD12C2A)
                              : Color(0xFF000000),
                          onTap: () {
                            HapticFeedback.vibrate();
                            BaseRepository.isAuthorized().then((isAuthorized) {
                              isAuthorized
                                  ? widget.product.isFavourite
                                      ? addRemoveFavouriteRepository
                                          .removeFromFavourites((widget.product
                                                ..isFavourite = false)
                                              .id)
                                      : addRemoveFavouriteRepository
                                          .addToFavourites((widget.product
                                                ..isFavourite = true)
                                              .id)
                                  : showCupertinoModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      expand: false,
                                      context: context,
                                      settings:
                                          RouteSettings(name: "/authorization"),
                                      useRootNavigator: true,
                                      builder: (context, controller) =>
                                          AuthorizationSheet());
                            });
                          },
                        )
                      : TBButtonData(
                          iconType: TBIconType.favorite,
                          onTap: () {},
                        ),
                  rightButtonData: TBButtonData(
                    iconType: TBIconType.share,
                  ),
                ),
              );
            });
          },
        );
      default:
        return RefashionedTopBar(
          data: TopBarData(
            leftButtonData: TBButtonData.icon(
              TBIconType.back,
              onTap: Navigator.of(context).pop,
            ),
          ),
        );
    }
  }

  Widget updateContent(Status status) {
    switch (status) {
      case Status.LOADING:
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: accentColor,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      case Status.ERROR:
        return Center(
          child: Text(
            "Ошибка при загрузке товара",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      case Status.LOADED:
        final product = productRepository?.response?.content;

        if (product == null)
          return Center(
            child: Text(
              "Нет продукта",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );

        return Material(
          color: Colors.white,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 99.0 + 45.0 + 20.0),
                children: <Widget>[
                  ProductSlider(
                    images: product.images,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ProductPrice(
                          product: product,
                        ),
                        ProductTitle(
                          product: product,
                        ),
                        ProductSeller(
                          seller: product.seller,
                          onSellerPush: widget.onSellerPush,
                        ),
                        ProductDescription(
                          product: product,
                        ),
                        ProductDelivery(
                          product: product,
                        ),
                        ProductAdditional(
                          product: product,
                          onSubCategoryClick: widget.onSubCategoryClick,
                        ),
                        RecommendedProducts(
                          product: product,
                          onProductPush: widget.onProductPush,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 99,
                child: ProductBottomButtons(
                  productId: widget.product.id,
                  onCartPush: widget.onCartPush,
                  openDeliveryTypesSelector: () =>
                      widget?.openDeliveryTypesSelector?.call(
                    context,
                    widget.product.id,
                    deliveryTypes: product.deliveryTypes,
                    pickUpAddress: product.pickUpAddress,
                    onFinish: (companyId, objectId) =>
                        widget.onCheckoutPush(companyId, objectId),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Center(
          child: Text(
            "Иной статус",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          updateTopBar(status),
          Expanded(
            child: updateContent(status),
          ),
        ],
      ),
    );
  }
}
