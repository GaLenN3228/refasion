import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

final basePath = "assets/icons/svg/";

enum IconAsset {
  back,
  more,
  forwardLong,
  sort,
  close,
  add,
  addThin,
  done,
  categories,
  star,

  favoriteBorder,
  favoriteFilled,
  share,
  filters,
  search,
  hanger,
  settings,
  settingsRounded,

  delete,
  mapPin,
  image,
  camera,
  cameraRotate,
  info,
  edit,
  duplicate,
  archive,

  home,
  catalog,
  addCircle,
  message,
  cart,
  cartThin,
  person,
  personThin,
  next,

  box,
  coupon,
  location,
  bank_card,
  courierDelivery,
  expressDelivery,
  geolocation,
  compass,
  notifications,
  order,

  marketPlaceCategory1,
  marketPlaceCategory2,
  marketPlaceCategory3,

  remove_from_publication,

  paymentFailed,
}

final assets = {
  IconAsset.add: "add.svg",
  IconAsset.next: "next.svg",
  IconAsset.addCircle: "add_circle.svg",
  IconAsset.addThin: "add_thin.svg",
  IconAsset.archive: "archive.svg",
  IconAsset.back: "back.svg",
  IconAsset.bank_card: "bank_card.svg",
  IconAsset.box: "box.svg",
  IconAsset.camera: "camera.svg",
  IconAsset.cameraRotate: "camera_rotate.svg",
  IconAsset.catalog: "catalog.svg",
  IconAsset.categories: "categories.svg",
  IconAsset.cart: "cart.svg",
  IconAsset.cartThin: "cart_thin.svg",
  IconAsset.close: "close.svg",
  IconAsset.compass: "compass.svg",
  IconAsset.coupon: "coupon.svg",
  IconAsset.courierDelivery: "courier_devilery.svg",
  IconAsset.delete: "delete.svg",
  IconAsset.done: "done.svg",
  IconAsset.duplicate: "duplicate.svg",
  IconAsset.edit: "edit.svg",
  IconAsset.expressDelivery: "express_delivery.svg",
  IconAsset.favoriteBorder: "favorite_border.svg",
  IconAsset.favoriteFilled: "favorite_filled.svg",
  IconAsset.filters: "filters.svg",
  IconAsset.forwardLong: "forward_long.svg",
  IconAsset.geolocation: "geolocation.svg",
  IconAsset.hanger: "hanger.svg",
  IconAsset.home: "home.svg",
  IconAsset.image: "image.svg",
  IconAsset.info: "info.svg",
  IconAsset.location: "location.svg",
  IconAsset.mapPin: "map_pin.svg",
  IconAsset.message: "message.svg",
  IconAsset.more: "more.svg",
  IconAsset.notifications: "notifications.svg",
  IconAsset.order: "order.svg",
  IconAsset.person: "person.svg",
  IconAsset.personThin: "person_thin.svg",
  IconAsset.search: "search.svg",
  IconAsset.settings: "settings.svg",
  IconAsset.settingsRounded: "settings_rounded.svg",
  IconAsset.share: "share.svg",
  IconAsset.sort: "sort.svg",
  IconAsset.star: "star.svg",
  IconAsset.marketPlaceCategory1: "market_place_category_1.svg",
  IconAsset.marketPlaceCategory2: "market_place_category_2.svg",
  IconAsset.marketPlaceCategory3: "market_place_category_3.svg",
  IconAsset.remove_from_publication: "remove_from_publication.svg",
  IconAsset.paymentFailed: "payment_failed.svg",
};

class SVGIcon extends StatelessWidget {
  final IconAsset icon;
  final double width;
  final double size;
  final double height;
  final Color color;

  const SVGIcon({this.icon, this.size: 30, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    if (icon == null)
      return SizedBox(
        width: width ?? size,
        height: height ?? size,
      );

    return SvgPicture.asset(
      basePath + assets[icon],
      width: width ?? size,
      height: height ?? size,
      color: color,
    );
  }
}
