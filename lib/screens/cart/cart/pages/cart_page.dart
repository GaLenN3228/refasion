import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/cart/cart/components/cart_group.dart';
import 'package:refashioned_app/screens/cart/cart/components/price_total.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CartPage extends StatefulWidget {
  final bool needUpdate;

  final Function(Product) onProductPush;

  final Function(DeliveryType, Address) onDeliveryOptionPush;

  const CartPage(
      {Key key, this.needUpdate, this.onProductPush, this.onDeliveryOptionPush})
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

    onUpdate();

    super.initState();
  }

  onUpdate() => buttonState.value = buttonState.value == ButtonState.disabled
      ? ButtonState.enabled
      : ButtonState.disabled;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartRepository>(
      create: (_) => CartRepository()..getCart(),
      child: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                RefashionedTopBar(
                  data: TopBarData.simple(middleText: "Корзина"),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final repository = context.watch<CartRepository>();

                      if (repository.isLoaded) {
                        final cart = repository.response.content;

                        if (cart.groups.isEmpty)
                          return Center(
                            child: Text(
                              "Здесь пусто",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );

                        return ListView(
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
                        );
                      }

                      return Center(
                        child: Text(
                          repository.message,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      );
                    },
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
        ),
      ),
    );
  }
}
