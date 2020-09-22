import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/components/placeholders/cart_item_placeholder.dart';
import 'package:refashioned_app/screens/cart/components/placeholders/summary_placeholder.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class CartPlaceholder extends StatelessWidget {
  final List<int> scheme;
  final GlobalKey<AnimatedListState> listKey;

  const CartPlaceholder({Key key, this.scheme, this.listKey}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Column(
          children: <Widget>[
            RefashionedTopBar(
              data: TopBarData(
                type: TBType.MATERIAL,
                theme: TBTheme.DARK,
                middleData: TBMiddleData.title("Корзина"),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  AnimatedList(
                    initialItemCount: scheme.length,
                    padding: EdgeInsets.fromLTRB(
                        15, 0, 15, MediaQuery.of(context).padding.bottom + 65.0 + 45.0 + 20.0),
                    itemBuilder: (context, index, animation) {
                      print("index: " + index.toString());
                      Widget placeholder = Container(
                        color: Colors.red,
                        child: CartItemPlaceholder(
                          productsCount: scheme.elementAt(index),
                        ),
                      );

                      if (index == 0)
                        placeholder = Container(
                          color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                child: Text(
                                  "cart.text\n",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              placeholder,
                            ],
                          ),
                        );
                      else if (index == scheme.length - 1)
                        placeholder = Container(
                          color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              placeholder,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: SummaryPlaceholder(),
                              )
                            ],
                          ),
                        );

                      return SizeTransition(
                        axis: Axis.vertical,
                        sizeFactor: animation,
                        child: placeholder,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).padding.bottom + 65.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RefashionedButton(
                        data: ButtonData(
                          buttonContainerData: ButtonContainerData(
                            decorationType: ButtonDecorationType.gray,
                          ),
                          titleData: ButtonTitleData(
                            text: "Перейти к оформлению",
                            color: ButtonTitleColor.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
