import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class AddSellerReviewButton extends StatefulWidget {
  final RBState state;

  final Function() onPush;

  const AddSellerReviewButton({Key key, this.onPush, this.state}) : super(key: key);

  @override
  _AddSellerReviewButtonState createState() => _AddSellerReviewButtonState();
}

class _AddSellerReviewButtonState extends State<AddSellerReviewButton> {
  RBData buttonData;

  @override
  void initState() {
    buttonData = RBData.map(
      initState: RBState.enabled,
      data: {
        RBState.enabled: RBStateData.accent(
          title: "Оценить продавца",
          onTap: () => widget.onPush?.call(),
        ),
        RBState.disabled: RBStateData.disabled(
          title: "Оценить продавца",
        ),
        RBState.loading: RBStateData.loading(),
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
  void didUpdateWidget(covariant AddSellerReviewButton oldWidget) {
    switch (widget.state) {
      case RBState.enabled:
        buttonData.setState(
          RBState.enabled,
          animateTitleIn: buttonData.state != RBState.disabled,
          animateTitleOut: buttonData.state != RBState.disabled,
        );

        break;

      case RBState.loading:
        buttonData.setState(RBState.loading);

        break;

      default:
        buttonData.setState(
          RBState.disabled,
          animateTitleIn: buttonData.state != RBState.enabled,
          animateTitleOut: buttonData.state != RBState.enabled,
        );

        break;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => RefashionedButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        data: buttonData,
      );
}
