import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_image.dart';
import 'package:refashioned_app/utils/colors.dart';

class SplashScreen extends StatelessWidget {
  final String text;

  const SplashScreen({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return CupertinoPageScaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            SVGImage(
              image: ImageAsset.refashionedLogo,
              height: 50,
              color: white,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      text ?? "Маркетплейс брендовой одежды и обуви",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: white,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
