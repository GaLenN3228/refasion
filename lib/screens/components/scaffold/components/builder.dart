import 'package:flutter/material.dart';

class RefashionedBuilder extends PageRouteBuilder {
  final Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)
      transitionBuilder;

  final RouteSettings settings;

  RefashionedBuilder({this.settings, this.transitionBuilder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => SizedBox(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation.drive(Tween(begin: 0.5, end: 1.0)),
            child: FadeTransition(
              opacity: secondaryAnimation.drive(Tween(begin: 1.0, end: 0.5)),
              child: transitionBuilder(
                  context, animation, secondaryAnimation, child),
            ),
          ),
          settings: settings,
        );
}
