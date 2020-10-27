import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/models/seller_reviews/seller_review.dart';
import 'package:refashioned_app/repositories/reviews.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/seller/components/send_review_button.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendSellerReviewPage extends StatefulWidget {
  final Seller seller;
  final int rating;
  final Function() onPush;

  const SendSellerReviewPage({Key key, this.seller, this.onPush, this.rating}) : super(key: key);

  @override
  _SendSellerReviewPageState createState() => _SendSellerReviewPageState();
}

class _SendSellerReviewPageState extends State<SendSellerReviewPage> with WidgetsBindingObserver {
  String currentText;

  bool keyboardVisible;

  RBState buttonState;

  AddUserReviewRepository addUserReviewRepository;

  String customerName;

  SharedPreferences sharedPreferences;

  @override
  initState() {
    currentText = "";

    keyboardVisible = false;

    buttonState = RBState.disabled;

    addUserReviewRepository = AddUserReviewRepository();

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  onUpdate(String text) {
    setState(() => buttonState = text.isNotEmpty ? RBState.enabled : RBState.disabled);

    currentText = text;
  }

  onPush() async {
    setState(() => buttonState = RBState.loading);

    if (sharedPreferences == null) sharedPreferences = await SharedPreferences.getInstance();

    if (customerName == null && sharedPreferences.containsKey(Prefs.user_name))
      customerName = sharedPreferences.getString(Prefs.user_name);

    final sellerReview = SellerReview(
      customerName: customerName ?? "customer",
      rating: widget.rating,
      text: currentText,
      sellerId: widget.seller.id,
    );

    final data = jsonEncode(sellerReview.toJson());

    await Future.wait(
      [
        addUserReviewRepository.update(data),
        Future.delayed(
          const Duration(milliseconds: 800),
        ),
      ],
    );

    final response = addUserReviewRepository.response?.content;

    setState(() => buttonState = RBState.disabled);

    if (response != null)
      widget.onPush?.call();
    else
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            "Ошибка",
            style: Theme.of(context).textTheme.headline1,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              addUserReviewRepository.response?.errors?.messages ?? "Неизвестная ошибка",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: Navigator.of(context).pop,
              child: Text("ОК"),
            )
          ],
        ),
      );
  }

  @override
  void didChangeMetrics() {
    final newKeyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0;

    if (keyboardVisible != newKeyboardVisible) setState(() => keyboardVisible = newKeyboardVisible);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Напишите отзыв",
              onBack: Navigator.of(context).pop,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: TextField(
                    onChanged: onUpdate,
                    autofocus: true,
                    autocorrect: false,
                    expands: true,
                    maxLines: null,
                    cursorWidth: 2.0,
                    cursorRadius: Radius.circular(2.0),
                    cursorColor: Color(0xFFE6E6E6),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Поделитесь впечатлениями. Пожалуйста, воздержитесь от оскорблений и мата.",
                      hintMaxLines: 5,
                      hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                          ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: keyboardVisible ? 20 : MediaQuery.of(context).padding.bottom + 65.0,
                  child: SendSellerReviewButton(
                    state: buttonState,
                    onPush: onPush,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
