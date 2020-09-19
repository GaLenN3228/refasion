import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/components/cart_item_tile.dart';
import 'package:refashioned_app/screens/cart/components/price_total.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
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
    PickPoint pickUpAddress,
    Function() onClose,
    Function(String, String) onFinish,
  }) openDeliveryTypesSelector;

  final Function() onCatalogPush;

  final Function(Order) onCheckoutPush;

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
  ValueNotifier<ButtonState> buttonState;
  Map<ButtonState, ButtonData> buttonStatesData;

  @override
  initState() {
    buttonStatesData = {
      ButtonState.enabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.black,
        ),
        titleData: ButtonTitleData(
          text: "Перейти к оформлению",
          color: ButtonTitleColor.white,
        ),
      ),
      ButtonState.disabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.gray,
        ),
        titleData: ButtonTitleData(
          text: "Перейти к оформлению",
          color: ButtonTitleColor.white,
        ),
      ),
    };

    buttonState = ValueNotifier(ButtonState.disabled);

    super.initState();
  }

  onCheckoutPush() {
    if (buttonState.value == ButtonState.enabled) {
      HapticFeedback.lightImpact();

      widget.onCheckoutPush?.call(null);
    }
  }

  @override
  void dispose() {
    buttonState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.watch<CartRepository>();

    final cart = repository?.response?.content;

    buttonState.value =
        repository.canMakeOrder ? ButtonState.enabled : ButtonState.disabled;

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
                onTap: repository.selectionAction,
              ),
            ),
          ),
          Expanded(
            child: repository.isLoaded && cart != null && cart.groups.isNotEmpty
                ? Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.fromLTRB(15, 0, 15,
                            MediaQuery.of(context).padding.bottom + 65.0),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Text(
                              cart.text,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          for (final group in cart.groups)
                            CartItemTile(
                              cartItem: group,
                              openDeliveryTypesSelector:
                                  widget.openDeliveryTypesSelector,
                              onProductPush: widget.onProductPush,
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CartPriceTotal(
                              currentPriceAmount: cart.totalCurrentPrice,
                              discountPriceAmount: cart.totalDiscountPrice,
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 99,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RefashionedButton(
                            states: buttonState,
                            statesData: buttonStatesData,
                            animateContent: false,
                            onTap: onCheckoutPush,
                          ),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
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
  }
}
