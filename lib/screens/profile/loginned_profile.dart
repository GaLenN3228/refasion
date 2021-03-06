import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/size.dart';
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

import 'components/user_name_controller.dart';
import 'components/user_photo_controller.dart';

class AuthorizedProfilePage extends StatefulWidget {
  final Function() onFavClick;
  final Function() onUserProfileClick;
  final Function(Product) onProductPush;
  final Function() onSettingsClick;
  final Function() onMyAddressesPush;

  const AuthorizedProfilePage({
    Key key,
    this.onFavClick,
    this.onSettingsClick,
    this.onProductPush,
    this.onMyAddressesPush,
    this.onUserProfileClick,
  }) : super(key: key);

  @override
  _AuthorizedProfilePageState createState() => _AuthorizedProfilePageState();
}

class _AuthorizedProfilePageState extends State<AuthorizedProfilePage> {
  Widget loadIcon;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    loadIcon = SizedBox(width: 25.0, height: 25.0, child: const CupertinoActivityIndicator());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _appBar(context),
          Consumer<ProfileProductsRepository>(builder: (context, profileProductsRepository, child) {
            if (profileProductsRepository.fullReload && profileProductsRepository.isLoading) {
              return Expanded(
                child: Center(
                  child: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: accentColor,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              );
            }

            if (profileProductsRepository.loadingFailed)
              return Expanded(
                child: Center(
                  child: Text("Ошибка", style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1),
                ),
              );

            if (profileProductsRepository.response?.content == null) {
              return SizedBox();
            }

            return _profileProducts(context, profileProductsRepository.response.content);
          }),
        ],
      ),
    );
  }

  Widget _appBar(context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Color(0xFF373A3F),
        height: MediaQuery
            .of(context)
            .padding
            .top + 80,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery
              .of(context)
              .padding
              .top, left: 20, right: 20),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: () {
              widget.onUserProfileClick();
            },
            child: Row(
              children: [
                Consumer<UserPhotoController>(builder: (context, userPhotoController, child) {
                  return Container(
                      width: 50,
                      height: 50,
                      child: FutureBuilder(
                          future: SharedPreferences.getInstance()
                              .then((prefs) => prefs.getString(Prefs.user_photo)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    File(snapshot.data),
                                    fit: BoxFit.cover,
                                  ));
                            }
                            return Image.asset('assets/icons/png/user_placeholder_yellow.png');
                          }));
                }),
                Consumer<UserNameController>(builder: (context, userNameController, child) {
                  return Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder(
                          future: SharedPreferences.getInstance(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              SharedPreferences sp = snapshot.data;
                              return sp.containsKey(Prefs.user_name)
                                  ? Text(
                                sp.getString(Prefs.user_name),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )
                                  : Text(
                                sp.getString(Prefs.user_phone),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
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
                  );
                }),
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
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
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
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Мои заказы', style: textTheme.bodyText1)),
                    ],
                  ),
                ),
                Tapable(
                  padding: EdgeInsets.all(10),
                  onTap: widget.onMyAddressesPush?.call,
                  child: Column(
                    children: [
                      SVGIcon(
                        icon: IconAsset.location,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Мои адреса', style: textTheme.bodyText1)),
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
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text('Избранное', style: textTheme.bodyText1)),
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
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height - (268 + MediaQuery
          .of(context)
          .padding
          .top),
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
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
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
                          child: ChangeNotifierProvider<SizeRepository>(
                            create: (_) => SizeRepository(),
                            builder: (context, _) =>
                                MarketplaceNavigator(
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  },
                                  onProductCreated: (productData) {
                                    var addProductRepository = AddProductRepository();
                                    addProductRepository.addListener(() {
                                      if (addProductRepository.isLoaded) {
                                        Provider.of<ProfileProductsRepository>(
                                            this.context, listen: false)
                                          ..response = null
                                          ..getProducts();
                                      }
                                    });
                                    addProductRepository.addProduct(productData);
                                    Navigator.of(context).pop();
                                  },
                                ),
                          ),
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _profileProducts(context, ProductsContent productsContent) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
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
            await Provider.of<ProfileProductsRepository>(context, listen: false)
                .getProducts(makeFullReload: false);
            _refreshController.refreshCompleted();
          },
          child: ListView(
            padding: EdgeInsets.only(bottom: 80),
            shrinkWrap: true,
            children: <Widget>[
              _menuButtons(context),
              productsContent.products.isNotEmpty
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 24, bottom: 10),
                  child: Text(
                    "Мои вещи",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline2,
                  ),
                ),
                ...products
              ])
                  : _profilePlaceHolder(context)
            ],
          ),
        ));
  }
}
