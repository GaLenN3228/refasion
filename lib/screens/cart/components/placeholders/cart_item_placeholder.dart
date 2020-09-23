import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/cart/components/placeholders/cart_product_placeholder.dart';
import 'package:refashioned_app/screens/cart/components/placeholders/delivery_data_placeholder.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';

class CartItemPlaceholder extends StatefulWidget {
  final int productsCount;

  const CartItemPlaceholder({Key key, this.productsCount}) : super(key: key);

  @override
  _CartItemPlaceholderState createState() => _CartItemPlaceholderState();
}

class _CartItemPlaceholderState extends State<CartItemPlaceholder> with WidgetsBindingObserver {
  GlobalKey<AnimatedListState> listKey;

  int productCount;

  @override
  initState() {
    productCount = 0;

    listKey = GlobalKey<AnimatedListState>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));

      update();
    });

    super.initState();
  }

  Widget item(int index) {
    Widget placeholder = CartProductPlaceholder();

    if (index == widget.productsCount - 1)
      placeholder = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          placeholder,
          DeliveryDataPlaceholder(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ItemsDivider(
              padding: 5,
            ),
          ),
        ],
      );

    return placeholder;
  }

  Widget itemBuilder(BuildContext context, int index, animation) => SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item(index),
      );

  update() async {
    if (productCount != widget.productsCount) {
      print("productsCount: " + productCount.toString() + " -> " + widget.productsCount.toString());

      // print("productsCount: " + productCount.toString() + " -> " + widget.productsCount.toString());
      if (productCount < widget.productsCount) {
        print("adding");

        await listKey.currentState.insertItem(
          0,
          duration: const Duration(seconds: 1),
        );

        productCount++;
        update();
      } else {
        print("removing");

        listKey.currentState.removeItem(
          0,
          (_, animation) => itemBuilder(context, 0, animation),
          duration: const Duration(seconds: 1),
        );

        productCount--;
        update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      initialItemCount: widget.productsCount,
      padding: EdgeInsets.zero,
      itemBuilder: itemBuilder,
    );
  }
}
