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
    addCartRepository = AddCartRepository(widget.productId);

    addCartRepository.addListener(repositoryListener);
  }

  repositoryListener() {
    if (addCartRepository != null) {
      if (addCartRepository.isLoading) buttonStates.value = ButtonState.loading;
      if (addCartRepository.isLoaded) {
        HapticFeedback.lightImpact();
        buttonStates.value = ButtonState.done;
        CartCountRepository.notify(context, Uri.parse(Url.cartItem));
      }
      if (addCartRepository.loadingFailed) {
        HapticFeedback.mediumImpact();
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
      decorationType: ButtonDecorationType.accent,
      titleText: "В корзину",
      titleColor: ButtonTitleColor.black,
    ),
    ButtonState.loading: ButtonData(
      decorationType: ButtonDecorationType.black,
      titleText: "Добавляем",
      titleColor: ButtonTitleColor.white,
    ),
    ButtonState.done: ButtonData(
      decorationType: ButtonDecorationType.outlined,
      titleText: "Добавлено",
      titleColor: ButtonTitleColor.black,
      rightIcon: ButtonIconType.arrow_right_long,
      rightIconColor: ButtonIconColor.black,
    ),
    ButtonState.error: ButtonData(
      decorationType: ButtonDecorationType.red,
      titleText: "Ошибка",
      titleColor: ButtonTitleColor.black,
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
                data: ButtonData(
                    decorationType: ButtonDecorationType.black,
                    titleText: "Спросить",
                    titleColor: ButtonTitleColor.white,
                    leftIcon: ButtonIconType.none),
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
