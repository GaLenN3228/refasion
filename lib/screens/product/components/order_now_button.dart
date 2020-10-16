import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class OrderNowButton extends StatefulWidget {
  final RBState state;
  final Function() onEnabledPush;
  final EdgeInsets padding;

  const OrderNowButton({Key key, this.state, this.onEnabledPush, this.padding}) : super(key: key);

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      height: 40,
      initState: widget?.state ?? RBState.disabled,
      data: {
        RBState.enabled: RBStateData.enabled(
          title: "Купить сейчас",
          onTap: () => widget.onEnabledPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Купить сейчас",
        ),
        RBState.loading: RBStateData.loading(),
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
  void didUpdateWidget(covariant OrderNowButton oldWidget) {
    buttonData.setState(widget.state);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefashionedButton(
        padding: widget.padding,
        data: buttonData,
      );
}
