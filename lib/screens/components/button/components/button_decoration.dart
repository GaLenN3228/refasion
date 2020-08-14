import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

enum ButtonDecorationType { black, accent, outlined, red }

class ButtonContainerData {
  final ButtonDecorationType decorationType;

  final double cornerRadius;
  final double borderWidth;

  ButtonContainerData({
    this.decorationType,
    this.cornerRadius: 5,
    this.borderWidth: 2,
  }) : assert((decorationType != null));
}

class ButtonContainer extends StatefulWidget {
  final ButtonContainerData data;
  final ValueNotifier<ButtonContainerData> statesData;

  final Widget child;

  const ButtonContainer({this.data, this.statesData, this.child})
      : assert(data != null || statesData != null);

  @override
  _ButtonContainerState createState() => _ButtonContainerState();
}

class _ButtonContainerState extends State<ButtonContainer> {
  ButtonContainerData data;

  BorderRadius borderRadius;
  ShapeDecoration shapeDecoration;

  @override
  void initState() {
    data = widget.statesData != null ? widget.statesData.value : widget.data;

    updateShape();

    widget.statesData?.addListener(buttonStateListener);

    super.initState();
  }

  updateShape() {
    borderRadius = BorderRadius.circular(data.cornerRadius);

    switch (data.decorationType) {
      case ButtonDecorationType.black:
        shapeDecoration = ShapeDecoration(
          color: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );
        break;
      case ButtonDecorationType.accent:
        shapeDecoration = ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );
        break;
      case ButtonDecorationType.outlined:
        shapeDecoration = ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: primaryColor, width: data.borderWidth),
          ),
        );
        break;
      case ButtonDecorationType.red:
        shapeDecoration = ShapeDecoration(
          color: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );
        break;
    }
  }

  buttonStateListener() {
    setState(() {
      data = widget.statesData != null ? widget.statesData.value : widget.data;

      updateShape();
    });
  }

  @override
  dispose() {
    widget.statesData?.removeListener(buttonStateListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      height: double.infinity,
      width: double.infinity,
      decoration: shapeDecoration,
    );
  }
}
