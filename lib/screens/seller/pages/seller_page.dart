import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/favourites.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';
import 'package:refashioned_app/screens/seller/components/seller_rating.dart';
import 'package:refashioned_app/utils/colors.dart';

class SellerPage extends StatelessWidget {
  final Seller seller;
  final Function(Function()) onSellerReviewsPush;
  final Function(Product) onProductPush;

  const SellerPage({Key key, this.seller, this.onProductPush, this.onSellerReviewsPush}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: white,
        child: Column(
          children: [
            RefashionedTopBar(
              data: TopBarData(
                type: TBType.MATERIAL,
                theme: TBTheme.DARK,
                middleData: TBMiddleData.custom(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          ClipOval(
                            child: seller.image != null
                                ? Image.network(
                                    seller.image,
                                  )
                                : Image.asset(
                                    "assets/images/png/seller.png",
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, right: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    seller.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: white,
                                        ),
                                  ),
                                  Text(
                                    "Частное лицо",
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                leftButtonData: TBButtonData.icon(
                  TBIconType.back,
                  color: white,
                  onTap: Navigator.of(context).pop,
                ),
              ),
            ),
            SellerRating(
              seller: seller,
              onSellerReviewsPush: (Function() callback) => onSellerReviewsPush?.call(
                () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                  callback?.call();
                },
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<AddRemoveFavouriteRepository>(
                create: (_) => AddRemoveFavouriteRepository(),
                builder: (context, _) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ProductsPage(
                    parameters: "?p=" + seller.id,
                    title: "Все вещи",
                    onPush: (product, {callback}) => onProductPush?.call(product),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
