import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/utils/colors.dart';

class RefashionedMessage extends StatelessWidget {
  final String title;
  final String message;
  final String moreInfoText;

  const RefashionedMessage({Key key, this.title, this.message, this.moreInfoText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null) return SizedBox();

    return Container(
      decoration: ShapeDecoration(
        color: accentColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: accentColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          RichText(
            // textAlign: TextAlign.center,
            text: TextSpan(
              text: message,
              style: Theme.of(context).textTheme.subtitle2.copyWith(color: primaryColor),
              children: [
                if (moreInfoText != null)
                  TextSpan(
                      text: moreInfoText,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
