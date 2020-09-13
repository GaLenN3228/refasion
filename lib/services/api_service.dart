import 'package:dio/dio.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/services/api/dio_client.dart';
import 'package:refashioned_app/utils/url.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ApiService {
  //FIXME set LOG_ENABLE = false in release build
  static const LOG_ENABLE = true;

  //ADDRESSES

  static const LOG_ADDRESSES = true;

  static Future<Response> findAddressesByQuery(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ADDRESSES);
    final queryParameters = {'q': query};
    return dioClient.get(Url.findAddressesByQuery,
        queryParameters: queryParameters);
  }

  static Future<Response> findAddressByCoordinates(Point coordinates) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ADDRESSES);
    final queryParameters = {
      'lat': coordinates.latitude,
      'lon': coordinates.longitude
    };
    return dioClient.get(Url.findAddressByCoordinates,
        queryParameters: queryParameters);
  }

  static getAddresses() async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_ADDRESSES);
    return dioClient.get(Url.addresses);
  }

  static getAddress(String id) async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_ADDRESSES);
    final path = id + "/";
    return dioClient.get(Url.addresses + path);
  }

  static addAddress(String json) async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_ADDRESSES);
    return dioClient.post(Url.addresses, data: json);
  }

  static removeAddress(String id) async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_ADDRESSES);
    final path = id + "/";
    return dioClient.delete(Url.addresses + path);
  }

  //CART

  static const LOG_CART = true;

  static Future<Response> getCart() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART);
    return dioClient.get(Url.cart);
  }

  static addProductToCart(String productId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART);
    final body = {"product": productId};
    return dioClient.post(Url.cart, data: body);
  }

  static removeItemFromCart(String itemId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART);
    final id = itemId + "/";
    return dioClient.delete(Url.cartItemProduct + id);
  }

  static getCartItemDeliveryTypes(String itemId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART);
    final path = itemId + "/delivery-types/";
    return dioClient.get(Url.cartItem + path);
  }

  static setCartItemDeliveryType(String itemId, String deliveryObjectId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART);
    final path = itemId + "/delivery-types/";
    return dioClient.patch(Url.cartItem + path);
  }

  //

  static Future<Response> getCategories() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.categories);
  }

  static Future<Response> getProducts({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.products + (parameters ?? ''));
  }

  static Future<Response> getSearchResults(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogSearch + query);
  }

  static Future<Response> getProduct(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.products + id + "/");
  }

  static Future<Response> getContentCatalogMenu() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsCount + (parameters ?? ''));
  }

  static Future<Response> getSellProperties({String category}) async {
    if (category == null) return null;

    return DioClient().getClient(logging: LOG_ENABLE).then((dio) =>
        dio.get(Url.properties, queryParameters: {"category": category}));
  }

  static Future<Response> getFilters() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.filters);
  }

  static Future<Response> getSortMethods() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.sortMethods);
  }

  static Future<Response> getCities() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.getCities);
  }

  static Future<Response> getGeolocation() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.getGeolocation);
  }

  static Future<Response> selectCity(String city) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.post(Url.selectCity, data: city);
  }

  static Future<Response> search(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var queryParameters = {
      'q': query,
    };
    return dioClient.get(Url.search, queryParameters: queryParameters);
  }

  static Future<Response> getQuickFilters() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.quickFilters);
  }

  static Future<Response> getProductRecommended(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsRecommended(id));
  }

  static Future<Response> getPickPoints() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.pickPoints);
  }

  static Future<Response> sendPhone(String phone) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var body = {"phone": phone};
    return dioClient.post(Url.authorization, data: body);
  }

  static Future<Response> sendCode(
      String phone, String hash, String code) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"code": code};
    return dioClient.post(Url.codeAuthorization(phone, hash), data: body);
  }

  static Future<Response> getFavourites() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.wished);
  }

  static Future<Response> getFavouritesProducts() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.wishedProducts);
  }

  static Future<Response> addToFavourites(String productId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.post(Url.wished, data: body);
  }

  static Future<Response> removeFromFavourites(String productId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.delete(Url.wished, data: body);
  }

  static Future<Response> addProducts(ProductData productData) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {
      "name": productData.description,
      "description": productData.description,
      // "property_values": [
      //   "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      // ],
      "brand": productData.brand.id,
      "category": productData.category.id,
      "current_price": productData.price,
      "discount_price": productData.price,
      // "size": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "seller": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "is_published": true
    };
    return dioClient.post(Url.addProduct, data: body);
  }
}
