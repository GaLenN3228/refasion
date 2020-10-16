import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class AddToCartButton extends StatefulWidget {
  final RBState state;
  final Function() onEnabledPush;
  final Function() onDonePush;
  final EdgeInsets padding;

  const AddToCartButton({Key key, this.state, this.onEnabledPush, this.onDonePush, this.padding}) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      height: 40,
      initState: widget?.state ?? RBState.disabled,
      data: {
        RBState.enabled: RBStateData.accent(
          title: "В Корзину",
          onTap: () => widget.onEnabledPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "В Корзину",
        ),
        RBState.loading: RBStateData.loading(),
        RBState.done: RBStateData.outlined(
          title: "В корзину",
          onTap: () => widget.onDonePush?.call(),
        ),
        RBState.error: RBStateData.red(
          title: "Ошибка",
        ),
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    buttonData.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AddToCartButton oldWidget) {
    buttonData.setState(widget.state);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefashionedButton(
        padding: widget.padding,
        data: buttonData,
      );
}
