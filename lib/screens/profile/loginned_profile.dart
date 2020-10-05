import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/profile/components/profile_product_tile.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AuthorizedProfilePage extends StatefulWidget {
  final Function() onFavClick;
  final Function(Product) onProductPush;
  final Function() onSettingsClick;

  const AuthorizedProfilePage({Key key, this.onFavClick, this.onSettingsClick, this.onProductPush})
      : super(key: key);

  @override
  _AuthorizedProfilePageState createState() => _AuthorizedProfilePageState();
}

class _AuthorizedProfilePageState extends State<AuthorizedProfilePage> {
  Widget loadIcon;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    loadIcon = SizedBox(width: 25.0, height: 25.0, child: const CupertinoActivityIndicator());

    // if (profileProductsRepository.loadingFailed)
    //   return Center(
    //     child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
    //   );

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _appBar(context),
          Expanded(child: Consumer<ProfileProductsRepository>(
              builder: (context, profileProductsRepository, child) {
            if (profileProductsRepository.isLoading && profileProductsRepository.response == null) {
              return Center(
                  child: SizedBox(
                height: 32.0,
                width: 32.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: accentColor,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ));
            }
            return (!profileProductsRepository.loadingFailed &&
                    profileProductsRepository.response.content.products.isNotEmpty)
                ? _profileProducts(context, profileProductsRepository.response.content)
                : _profilePlaceHolder(context);
          }))
        ],
      ),
    );
  }

  Widget _appBar(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Color(0xFF373A3F),
        height: MediaQuery.of(context).padding.top + 80,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: () {},
            child: Row(
              children: [
                // Container(
                //   width: 70,
                //   height: 70,
                //   child: Image.asset('assets/user_placeholder.png'),
                // ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder(
                        future: SharedPreferences.getInstance()
                            .then((prefs) => prefs.getString(Prefs.user_name)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      Text(
                        'Мой профиль',
                        style: textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SVGIcon(
                  icon: IconAsset.next,
                  height: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButtons(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tapable(
                  onTap: () {},
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.box,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Мои заказы', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  onTap: () {
                    widget.onFavClick();
                  },
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.favoriteBorder,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Избранное', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: () {},
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.notifications,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Подписки', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: () {
                    widget.onSettingsClick();
                  },
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.settings,
                        height: 35,
                        color: Colors.black,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text(
                            'Настройки',
                            style: textTheme.bodyText1,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ItemsDivider(padding: 0),
        ],
      ),
    );
  }

  Widget _profilePlaceHolder(context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        child: Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SVGIcon(
                  icon: IconAsset.hanger,
                  size: 48,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 250,
                  child: Text(
                    "Ваш гардероб пуст",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 230,
                  child: Text(
                    "Вы еще не разместили ни одной вещи в вашем гардеробе",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (context) => MarketplaceNavigator(
                      onClose: Navigator.of(context).pop,
                    ),
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 35,
                decoration: ShapeDecoration(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "РАЗМЕСТИТЬ ВЕЩЬ".toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _profileProducts(context, ProductsContent productsContent) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var products = List<Widget>();
    productsContent.products.asMap().forEach((key, value) {
      products.add(Column(children: <Widget>[
        ProfileProductTile(
          product: value,
          onProductPush: widget.onProductPush,
        ),
        if (key != productsContent.products.length - 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ItemsDivider(
              padding: 16,
            ),
          )
      ]));
    });
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: ClassicHeader(
          completeDuration: Duration.zero,
          completeIcon: null,
          completeText: "",
          idleIcon: loadIcon,
          idleText: "Обновление",
          refreshingText: "Обновление",
          refreshingIcon: loadIcon,
          releaseIcon: loadIcon,
          releaseText: "Обновление",
        ),
        controller: _refreshController,
        onRefresh: () async {
          HapticFeedback.heavyImpact();
          await Provider.of<ProfileProductsRepository>(context, listen: false).getProducts();
          _refreshController.refreshCompleted();
        },
        child: ListView(
          padding: EdgeInsets.only(bottom: 80),
          shrinkWrap: true,
          children: <Widget>[
            _menuButtons(context),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24, bottom: 10),
              child: Text(
                "Мои вещи",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            ...products
          ],
        ),
      ),
    );
  }
}
