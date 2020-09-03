import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/services/local/local_service.dart';
import 'package:refashioned_app/utils/url.dart';
import 'base.dart';

class CartCountRepository extends BaseRepository {
  String cartCount = "0";

  Future<void> getCartCount(Uri responseUri) => localCall(() async {
        this.cartCount =
            await LocalService.getCartCountFromCookies(responseUri != null ? responseUri : Uri.parse(Url.cartItem));
      });

  static notify(BuildContext context, Uri responseUri) {
    Provider.of<CartCountRepository>(context, listen: false).getCartCount(responseUri);
  }
}
