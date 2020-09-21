import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_icon.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';

class ProductBottomButtons extends StatefulWidget {
  final String productId;
  final Function() onCartPush;
  final Function() openDeliveryTypesSelector;

  const ProductBottomButtons(
      {this.productId, this.onCartPush, this.openDeliveryTypesSelector});
  @override
  _ProductBottomButtonsState createState() => _ProductBottomButtonsState();
}

class _ProductBottomButtonsState extends State<ProductBottomButtons> {
  CartRepository cartRepository;

  ValueNotifier<ButtonState> addToCartButtonState;

  @override
  void initState() {
    addToCartButtonState = ValueNotifier<ButtonState>(ButtonState.disabled);

    cartRepository = Provider.of<CartRepository>(context, listen: false);

    if (cartRepository != null)
      addToCartButtonState.value = ButtonState.enabled;

    if (cartRepository.checkPresence(widget.productId))
      addToCartButtonState.value = ButtonState.done;

    if (addToCartButtonState.value != ButtonState.done)
      cartRepository?.addProduct?.addListener(addToCartRepositoryListener);

    super.initState();
  }

  addToCart() {
    if (addToCartButtonState.value != ButtonState.done) {
      HapticFeedback.mediumImpact();
      cartRepository?.addToCart(widget.productId);
    } else
      widget.onCartPush();
  }

  addToCartRepositoryListener() {
    if (cartRepository != null && cartRepository.addProduct.productId == widget.productId) {
      switch (cartRepository.addProduct.status) {
        case Status.LOADING:
          addToCartButtonState.value = ButtonState.loading;
          break;
        case Status.ERROR:
          HapticFeedback.vibrate();
          addToCartButtonState.value = ButtonState.error;
          break;
        case Status.LOADED:
          addToCartButtonState.value = ButtonState.done;
          break;
      }
    }
  }

  @override
  void dispose() {
    cartRepository?.addProduct?.removeListener(addToCartRepositoryListener);

    super.dispose();
  }

  final addToCartButtonStatesData = {
    ButtonState.disabled: ButtonData(
      buttonContainerData: ButtonContainerData(
        decorationType: ButtonDecorationType.gray,
      ),
      titleData: ButtonTitleData(
        text: "В корзину",
        color: ButtonTitleColor.white,
      ),
    ),
    ButtonState.enabled: ButtonData(
      buttonContainerData: ButtonContainerData(
        decorationType: ButtonDecorationType.accent,
      ),
      titleData: ButtonTitleData(
        text: "В корзину",
        color: ButtonTitleColor.black,
      ),
    ),
    ButtonState.loading: ButtonData(
      buttonContainerData: ButtonContainerData(
        decorationType: ButtonDecorationType.black,
      ),
      titleData: ButtonTitleData(
        text: "Добавляем",
        color: ButtonTitleColor.white,
      ),
    ),
    ButtonState.done: ButtonData(
      buttonContainerData: ButtonContainerData(
        decorationType: ButtonDecorationType.outlined,
      ),
      titleData: ButtonTitleData(
        text: "Добавлено",
        color: ButtonTitleColor.black,
      ),
      rightIconData: ButtonIconData(
        icon: ButtonIconType.arrow_right_long,
        color: ButtonIconColor.black,
      ),
    ),
    ButtonState.error: ButtonData(
      buttonContainerData: ButtonContainerData(
        decorationType: ButtonDecorationType.red,
      ),
      titleData: ButtonTitleData(
        text: "Ошибка",
        color: ButtonTitleColor.white,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    if (widget.productId == null) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RefashionedButton(
              height: 40,
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.openDeliveryTypesSelector();
              },
              data: ButtonData(
                buttonContainerData: ButtonContainerData(
                  decorationType: ButtonDecorationType.black,
                ),
                titleData: ButtonTitleData(
                  text: "Купить сейчас",
                  color: ButtonTitleColor.white,
                ),
              ),
            ),
          ),
          Container(
            width: 5,
          ),
          Expanded(
            child: RefashionedButton(
              height: 40,
              onTap: addToCart,
              states: addToCartButtonState,
              statesData: addToCartButtonStatesData,
            ),
          ),
        ],
      ),
    );
  }
}
