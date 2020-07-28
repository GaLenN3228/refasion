import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  final ValueNotifier<bool> isScrolled;

  const Header({Key key, this.text, this.isScrolled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isScrolled ?? ValueNotifier(false),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: (value)
                  ? [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 4),
                          blurRadius: 4)
                    ]
                  : []),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 11, 20, 16),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
