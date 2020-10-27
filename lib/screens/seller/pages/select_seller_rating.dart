import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/screens/components/button/simple_button.dart';
import 'package:refashioned_app/screens/components/seller/rating_selector.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class SelectSellerRatingPage extends StatefulWidget {
  final Seller seller;
  final Function(int) onAddSellerReviewPush;

  const SelectSellerRatingPage({Key key, this.seller, this.onAddSellerReviewPush}) : super(key: key);

  @override
  _SelectSellerRatingPageState createState() => _SelectSellerRatingPageState();
}

class _SelectSellerRatingPageState extends State<SelectSellerRatingPage> {
  int currentIndex;
  bool buttonEnabled;

  @override
  initState() {
    currentIndex = -1;
    buttonEnabled = false;

    super.initState();
  }

  onSelect(int index) => setState(() {
        currentIndex = index;
        buttonEnabled = currentIndex >= 0;
      });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              middleText: "Оцените продавца",
              onBack: Navigator.of(context).pop,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      RatingSelector(
                        starSize: 40,
                        onSelect: onSelect,
                        selected: currentIndex,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Нажмите, чтобы оценить",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                color: darkGrayColor,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom + 65.0,
                  child: SimpleButton(
                    enabled: buttonEnabled,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    label: "Продолжить",
                    onPush: () => widget.onAddSellerReviewPush?.call(currentIndex + 1),
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
