import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/repositories/add_cart.dart';
import 'package:refashioned_app/repositories/cart_count.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_icon.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/utils/url.dart';

class ProductBottomButtons extends StatefulWidget {
  final String productId;

  const ProductBottomButtons({this.productId}) : assert(productId != null);
  @override
  _ProductBottomButtonsState createState() => _ProductBottomButtonsState();
}

class _ProductBottomButtonsState extends State<ProductBottomButtons> {
  AddCartRepository addCartRepository;
  ValueNotifier<ButtonState> buttonStates;

  @override
  void initState() {
    buttonStates = ValueNotifier<ButtonState>(ButtonState.enabled);

    super.initState();
  }

  addToCart() {
    HapticFeedback.mediumImpact();

    addCartRepository = AddCartRepository(widget.productId);

    addCartRepository.addListener(repositoryListener);
  }

  repositoryListener() {
    if (addCartRepository != null) {
      if (addCartRepository.isLoading) buttonStates.value = ButtonState.loading;
      if (addCartRepository.isLoaded) {
        buttonStates.value = ButtonState.done;
        CartCountRepository.notify(context, Uri.parse(Url.cartItem));
      }
      if (addCartRepository.loadingFailed) {
        HapticFeedback.vibrate();
        buttonStates.value = ButtonState.error;
      }
    }
  }

  @override
  void dispose() {
    addCartRepository?.removeListener(repositoryListener);

    addCartRepository?.dispose();

    super.dispose();
  }

  final buttonStatesData = {
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
        color: ButtonTitleColor.black,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RefashionedButton(
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
              ),
            ),
            Container(
              width: 5,
            ),
            Expanded(
              child: RefashionedButton(
                onTap: addToCart,
                states: buttonStates,
                statesData: buttonStatesData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
