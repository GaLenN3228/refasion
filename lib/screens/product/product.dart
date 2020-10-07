import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/repositories/orders.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/authorization/authorization_sheet.dart';
import 'package:refashioned_app/screens/components/message.dart';
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
import 'package:refashioned_app/utils/colors.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  final Function(Product) onProductPush;
  final Function(Seller) onSellerPush;
  final Function(String parameters, String title) onSubCategoryClick;
  final Function() onCartPush;
  final Function(PickPoint) onPickupAddressPush;
  final Function(Order) onCheckoutPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function() onFinish,
    Future<bool> Function(String, String) onSelect,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  const ProductPage({
    this.product,
    this.onProductPush,
    this.onSellerPush,
    this.onSubCategoryClick,
    this.onCartPush,
    this.openDeliveryTypesSelector,
    this.onPickupAddressPush,
    this.onCheckoutPush,
  }) : assert(product != null);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductRepository productRepository;

  CreateOrderRepository createOrderRepository;

  Order order;

  Status status;

  @override
  void initState() {
    status = Status.LOADING;

    productRepository = ProductRepository();
    productRepository.getProduct(widget.product.id);

    productRepository.statusNotifier.addListener(repositoryStatusListener);

    createOrderRepository = CreateOrderRepository();

    super.initState();
  }

  repositoryStatusListener() => setState(() => status = productRepository.statusNotifier.value);

  @override
  void dispose() {
    productRepository.statusNotifier.removeListener(repositoryStatusListener);

    productRepository.dispose();

    createOrderRepository.dispose();

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
          builder: (context) =>
              Consumer<AddRemoveFavouriteRepository>(builder: (context, addRemoveFavouriteRepository, child) {
            return RefashionedTopBar(
              data: TopBarData(
                  leftButtonData: TBButtonData.icon(
                    TBIconType.back,
                    onTap: Navigator.of(context).pop,
                  ),
                  middleData: TBMiddleData.condensed(
                    product.brand.name.toString() + " • " + product.name.toString(),
                    product.currentPrice.toString() + " ₽",
                  ),
                  rightButtonData: TBButtonData(
                    iconType: widget.product.isFavourite ? TBIconType.favoriteFilled : TBIconType.favorite,
                    iconColor: widget.product.isFavourite ? Color(0xFFD12C2A) : Color(0xFF000000),
                    animated: true,
                    onTap: () async {
                      HapticFeedback.heavyImpact();
                      await BaseRepository.isAuthorized().then((isAuthorized) {
                        isAuthorized
                            ? widget.product.isFavourite
                                ? addRemoveFavouriteRepository
                                    .removeFromFavourites((widget.product..isFavourite = false).id)
                                : addRemoveFavouriteRepository.addToFavourites((widget.product..isFavourite = true).id)
                            : showMaterialModalBottomSheet(
                                expand: false,
                                context: context,
                                useRootNavigator: true,
                                builder: (context, controller) => AuthorizationSheet());
                      });
                    },
                  )),
            );
          }),
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
            child: SizedBox(
          height: 32.0,
          width: 32.0,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: accentColor,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ));
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 65.0 + 45.0 + 22.0),
                children: <Widget>[
                  ProductSlider(
                    images: product.images,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (!product.available)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: RefashionedMessage(
                              title: "Товар в резерве",
                              message: "Этот товар уже оплатил другой покупатель, и он находится в резерве.",
                            ),
                          ),
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
                          onPickupAddressPush: widget.onPickupAddressPush,
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
              if (product.available)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 99,
                  child: ProductBottomButtons(
                    productId: widget.product.id,
                    onCartPush: widget.onCartPush,
                    openDeliveryTypesSelector: () => widget.openDeliveryTypesSelector?.call(
                      context,
                      product.id,
                      deliveryTypes: product.deliveryTypes,
                      onFinish: () => widget.onCheckoutPush?.call(order),
                      onSelect: (companyId, objectId) async {
                        await createOrderRepository.update(
                          jsonEncode(
                            [
                              {
                                "delivery_company": companyId,
                                "delivery_object_id": objectId,
                                "products": [product.id],
                              },
                            ],
                          ),
                        );

                        order = createOrderRepository.response?.content;

                        final result = order != null;

                        if (!result) {
                          showCupertinoDialog(
                            context: context,
                            useRootNavigator: true,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text(
                                "Ошибка",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  createOrderRepository.response?.errors?.messages ?? "Неизвестная ошибка",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: Navigator.of(context).pop,
                                  child: Text("ОК"),
                                )
                              ],
                            ),
                          );
                        }

                        return result;
                      },
                      originalOverlayStyle: SystemUiOverlayStyle.dark,
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
