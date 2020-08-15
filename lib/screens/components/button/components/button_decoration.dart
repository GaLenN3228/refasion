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

class ButtonContainer extends StatelessWidget {
  final ButtonContainerData currentData;
  final ButtonContainerData nextData;

  final Animation<double> animation;

  final Widget child;

  const ButtonContainer(
      {this.currentData, this.nextData, this.child, this.animation})
      : assert(currentData != null);

  selectDecoration(ButtonContainerData newData) {
    switch (newData.decorationType) {
      case ButtonDecorationType.black:
        return ShapeDecoration(
          color: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(newData.cornerRadius)),
        );
      case ButtonDecorationType.accent:
        return ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(newData.cornerRadius)),
        );
      case ButtonDecorationType.outlined:
        return ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
            side: BorderSide(color: primaryColor, width: newData.borderWidth),
          ),
        );
      case ButtonDecorationType.red:
        return ShapeDecoration(
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(newData.cornerRadius)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDecoration = selectDecoration(currentData);
    final nextDecoration = selectDecoration(nextData);

    final currentBorderRadius = BorderRadius.circular(currentData.cornerRadius);
    final nextBorderRadius = BorderRadius.circular(currentData.cornerRadius);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        child: ClipRRect(
          child: child,
          borderRadius: BorderRadius.lerp(
              currentBorderRadius, nextBorderRadius, animation.value),
        ),
        height: double.infinity,
        width: double.infinity,
        decoration: ShapeDecoration.lerp(
            currentDecoration, nextDecoration, animation.value),
      ),
    );
  }
}
