class Url {
  //Base URLs
  static const refashionedBaseUrl = 'https://api.refashioned.ru/v1';

  //Categories
  static const categories = '$refashionedBaseUrl/catalog/categories/';

  //Products
  static const products = '$refashionedBaseUrl/catalog/products/';
  static const productsCount = '$refashionedBaseUrl/catalog/products/count/';

  static String productsRecommended(id) => '$refashionedBaseUrl/catalog/products/' + id + '/recommended/';

  //SellProperties
  static const properties = '$refashionedBaseUrl/catalog/properties/';

  //Filters
  static const filters = '$refashionedBaseUrl/catalog/filters/';
  static const quick_filters = '$refashionedBaseUrl/catalog/quickfilters/';

  //Filters
  static const sortMethods = '$refashionedBaseUrl/catalog/sort/';

  //Cities
  static const getCities = '$refashionedBaseUrl/geo/cities/';
  static const getGeolocation = '$refashionedBaseUrl/geo/geolocation/';
  static const selectCity = '$refashionedBaseUrl/geo/cities/select/';

  //Content
  static const catalogMenu = '$refashionedBaseUrl/content/catalog-menu/';

  //Search
  static const search = '$refashionedBaseUrl/catalog/search/';

  //Cart
  static const cart_demo = 'https://itlessons.ru/assets/refashioned-cart.json';
  static const cartItem = '$refashionedBaseUrl/cart/item/';
  static const cart = '$refashionedBaseUrl/cart/';

  //Search catalogs, brands
  static const catalogSearch = '$refashionedBaseUrl/catalog/search/?q=';

  //Maps
  static const pickPoints = '$refashionedBaseUrl/pickpoints';

  //Authorization
  static const authorization = '$refashionedBaseUrl/users/authorization/';
  static String codeAuthorization(String phone, String hash) => '$authorization' + phone + '_' + hash + '/';
}
