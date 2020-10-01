import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart/cart.dart';
import 'package:refashioned_app/screens/cart/components/tiles/cart_item_tile.dart';
import 'package:refashioned_app/screens/cart/components/tiles/order_button.dart';
import 'package:refashioned_app/screens/cart/components/tiles/cart_summary_tile.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartPage extends StatefulWidget {
  final bool needUpdate;

  final Function(Product) onProductPush;

  final Function(
    BuildContext,
    String, {
    List<DeliveryType> deliveryTypes,
    Function() onClose,
    Function(String, String) onFinish,
    SystemUiOverlayStyle originalOverlayStyle,
  }) openDeliveryTypesSelector;

  final Function() onCatalogPush;

  final Function(String) onCheckoutPush;

  const CartPage(
      {Key key,
      this.needUpdate,
      this.onProductPush,
      this.openDeliveryTypesSelector,
      this.onCatalogPush,
      this.onCheckoutPush})
      : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget loadingIcon;

  RefreshController refreshController;

  @override
  void initState() {
    loadingIcon = SizedBox(
      width: 25.0,
      height: 25.0,
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? const CupertinoActivityIndicator()
          : CircularProgressIndicator(
              strokeWidth: 1,
              backgroundColor: accentColor,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ),
    );
    refreshController = RefreshController(initialRefresh: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<CartRepository>(
        builder: (context, repository, _) {
          // if (repository.isLoading)
          //   return CupertinoPageScaffold(
          //     child: Column(
          //       children: [
          //         RefashionedTopBar(
          //           data: TopBarData(
          //             type: TBType.MATERIAL,
          //             theme: TBTheme.DARK,
          //             middleData: TBMiddleData.title("Корзина"),
          //           ),
          //         ),
          //         Expanded(
          //           child: Center(
          //             child: loadingIcon,
          //           ),
          //         ),
          //         SizedBox(
          //           height: MediaQuery.of(context).padding.bottom + 65.0 + 45.0 + 20.0,
          //         ),
          //       ],
          //     ),
          //   );

          final cart = repository?.response?.content;

          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            child: Column(
              children: <Widget>[
                RefashionedTopBar(
                  data: TopBarData(
                    type: TBType.MATERIAL,
                    theme: TBTheme.DARK,
                    middleData: TBMiddleData.title("Корзина"),
                    rightButtonData: TBButtonData.text(
                      repository.selectionActionLabel,
                      onTap: () {
                        HapticFeedback.selectionClick();

                        repository.selectionAction?.call();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: cart != null && cart.groups.isNotEmpty
                      ? Stack(
                          children: [
                            SmartRefresher(
                              controller: refreshController,
                              enablePullDown: true,
                              enablePullUp: false,
                              header: ClassicHeader(
                                completeDuration: Duration.zero,
                                completeIcon: null,
                                completeText: "",
                                idleIcon: loadingIcon,
                                idleText: "Обновление",
                                refreshingText: "Обновление",
                                refreshingIcon: loadingIcon,
                                releaseIcon: loadingIcon,
                                releaseText: "Обновление",
                              ),
                              onRefresh: () async {
                                HapticFeedback.lightImpact();

                                await repository.update();

                                refreshController.refreshCompleted();
                              },
                              child: ListView(
                                padding: EdgeInsets.fromLTRB(
                                    15, 0, 15, MediaQuery.of(context).padding.bottom + 65.0 + 45.0 + 20.0),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                    child: Text(
                                      cart.text,
                                      style: Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                  for (final group in cart.groups)
                                    CartItemTile(
                                      cartItem: group,
                                      openDeliveryTypesSelector: widget.openDeliveryTypesSelector,
                                      onProductPush: widget.onProductPush,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: CartSummaryTile(
                                      cartSummary: repository.summary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: MediaQuery.of(context).padding.bottom + 65.0,
                              child: CartOrderButton(
                                cartSummary: repository.summary,
                                onCheckoutPush: () async =>
                                    await widget.onCheckoutPush?.call(repository.orderParameters),
                              ),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SVGIcon(
                                    icon: IconAsset.cartThin,
                                    size: 48,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      "В корзине пока пусто",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.headline1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: SizedBox(
                                    width: 230,
                                    child: Text(
                                      "Вы ещё не положили в корзину ни одной вещи",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(28),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: widget.onCatalogPush,
                                child: Container(
                                  width: 180,
                                  height: 35,
                                  decoration: ShapeDecoration(
                                    color: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Перейти в каталог".toUpperCase(),
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          );
        },
      );
}
