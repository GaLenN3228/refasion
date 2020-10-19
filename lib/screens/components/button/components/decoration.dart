import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/data/decoration.dart';
import 'package:refashioned_app/utils/colors.dart';

class ButtonContainer extends StatelessWidget {
  final RBDecorationData currentData;
  final RBDecorationData nextData;

  final Animation<double> animation;

  final Widget child;

  const ButtonContainer({Key key, this.currentData, this.nextData, this.animation, this.child}) : super(key: key);

  selectDecoration(RBDecorationData newData) {
    switch (newData.decorationType) {
      case RBDecoration.black:
        return ShapeDecoration(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
          ),
        );
      case RBDecoration.gray:
        return ShapeDecoration(
          color: Color(0xFFBFBFBF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
          ),
        );
      case RBDecoration.accent:
        return ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
          ),
        );
      case RBDecoration.outlined:
        return ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
            side: BorderSide(color: primaryColor, width: newData.borderWidth),
          ),
        );
      case RBDecoration.red:
        return ShapeDecoration(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(newData.cornerRadius),
          ),
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
            currentBorderRadius,
            nextBorderRadius,
            animation.value,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        decoration: ShapeDecoration.lerp(
          currentDecoration,
          nextDecoration,
          animation.value,
        ),
      ),
    );
  }
}
