import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/cart/components/cart_group.dart';
import 'package:refashioned_app/screens/cart/cart/components/price_total.dart';
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

  final Function(DeliveryType, PickPoint, Function()) onDeliveryOptionPush;

  final Function() onCatalogPush;

  const CartPage(
      {Key key,
      this.needUpdate,
      this.onProductPush,
      this.onDeliveryOptionPush,
      this.onCatalogPush})
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

  onUpdate() {
    buttonState.value = buttonState.value == ButtonState.disabled
        ? ButtonState.enabled
        : ButtonState.disabled;
  }

  @override
  void dispose() {
    buttonState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          RefashionedTopBar(
            data: TopBarData(
              type: TBType.MATERIAL,
              theme: TBTheme.DARK,
              middleData: TBMiddleData.title("Корзина"),
              rightButtonData: TBButtonData.text("Выбрать всё"),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final repository = context.watch<CartRepository>();

                if (repository.isLoaded) {
                  final cart = repository.response.content;

                  if (cart.groups.isNotEmpty)
                    return Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.fromLTRB(
                              15, 0, 15, 99.0 + 55.0 + 20.0),
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
                              CartGroup(
                                data: group,
                                onOptionPush: widget.onDeliveryOptionPush,
                                onProductPush: widget.onProductPush,
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                              onTap: onUpdate,
                            ),
                          ),
                        )
                      ],
                    );
                }

                return Column(
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
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
