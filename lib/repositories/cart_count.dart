import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/utils/url.dart';
import '../services/api_service.dart';
import 'base.dart';

class CartCountRepository extends BaseRepository {
  String cartCount = "0";

  @override
  Future<void> loadData({@required Uri responseUri}) async {
    try {
      this.cartCount = await ApiService.getCartCountFromCookies(responseUri != null ? responseUri : Uri.parse(Url.cartItem));
      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  static notify(BuildContext context, Uri responseUri){
    Provider.of<CartCountRepository>(context, listen: false).loadData(responseUri: responseUri);
  }
}
