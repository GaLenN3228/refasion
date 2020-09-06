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

  const ProductBottomButtons({this.productId, this.onCartPush});
  @override
  _ProductBottomButtonsState createState() => _ProductBottomButtonsState();
}

class _ProductBottomButtonsState extends State<ProductBottomButtons> {
  CartRepository cartRepository;
  ValueNotifier<ButtonState> buttonState;

  @override
  void initState() {
    buttonState = ValueNotifier<ButtonState>(ButtonState.disabled);

    cartRepository = Provider.of<CartRepository>(context, listen: false);

    if (cartRepository != null) buttonState.value = ButtonState.enabled;

    if (cartRepository.checkPresence(widget.productId))
      buttonState.value = ButtonState.done;

    if (buttonState.value != ButtonState.done)
      cartRepository?.addProduct?.addListener(repositoryListener);

    super.initState();
  }

  addToCart() {
    if (buttonState.value != ButtonState.done) {
      HapticFeedback.mediumImpact();
      cartRepository?.addToCart(widget.productId);
    } else
      widget.onCartPush();
  }

  repositoryListener() {
    if (cartRepository != null) {
      switch (cartRepository.addProduct.status) {
        case Status.LOADING:
          buttonState.value = ButtonState.loading;
          break;
        case Status.ERROR:
          HapticFeedback.vibrate();
          buttonState.value = ButtonState.error;
          break;
        case Status.LOADED:
          buttonState.value = ButtonState.done;
          break;
      }
    }
  }

  @override
  void dispose() {
    cartRepository?.addProduct?.removeListener(repositoryListener);

    super.dispose();
  }

  final buttonStatesData = {
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: widget.productId != null && widget.productId.isNotEmpty
                ? RefashionedButton(
                    height: 40,
                    onTap: () => HapticFeedback.mediumImpact(),
                    data: ButtonData(
                      buttonContainerData: ButtonContainerData(
                        decorationType: ButtonDecorationType.black,
                      ),
                      titleData: ButtonTitleData(
                        text: "Спросить",
                        color: ButtonTitleColor.white,
                      ),
                    ),
                  )
                : RefashionedButton(
                    height: 40,
                    data: ButtonData(
                        buttonContainerData: ButtonContainerData(
                      decorationType: ButtonDecorationType.black,
                    )),
                  ),
          ),
          Container(
            width: 5,
          ),
          Expanded(
            child: RefashionedButton(
              height: 40,
              onTap: addToCart,
              states: buttonState,
              statesData: buttonStatesData,
            ),
          ),
        ],
      ),
    );
  }
}
