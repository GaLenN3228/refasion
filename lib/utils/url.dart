class Url {
  //Base URLs
  static const refashionedBaseUrl = 'https://api.refashioned.ru/v1';

  //ADDRESSES

  static const findAddressByCoordinates =
      '$refashionedBaseUrl/geo/geocode/latlon/';
  static const findAddressesByQuery =
      '$refashionedBaseUrl/geo/geocode/suggestions/';

  //CART

  static const cart_demo = 'https://itlessons.ru/assets/refashioned-cart.json';
  static const cart = '$refashionedBaseUrl/cart/';
  static const cartItemProduct = '$refashionedBaseUrl/cart/item_product/';
  static const cartItem = '$refashionedBaseUrl/cart/item/';

  //ORDERS

  static const orders = '$refashionedBaseUrl/orders/';

  //USER ADDRESSES

  static const userAddresses = '$refashionedBaseUrl/geo/addresses/';

  //USER PICKPOINTS

  static const userPickPoints = '$refashionedBaseUrl/geo/pickpoints/';

  //Categories
  static const categories = '$refashionedBaseUrl/catalog/categories/';
  static String categoryBrands(id) => '$categories' + id + '/brands/';

  //Products
  static const products = '$refashionedBaseUrl/catalog/products/';
  static const productsCount = '$refashionedBaseUrl/catalog/products/count/';
  static const addProduct = '$refashionedBaseUrl/catalog/products/create/';
  static const calcProductPrice = '$refashionedBaseUrl/catalog/price-calc/';

  static String productsRecommended(id) =>
      '$refashionedBaseUrl/catalog/products/' + id + '/recommended/';

  //SellProperties
  static const properties = '$refashionedBaseUrl/catalog/properties/all/';

  //Filters
  static const filters = '$refashionedBaseUrl/catalog/filters/';
  static const quickFilters = '$refashionedBaseUrl/catalog/quickfilters/';

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

  //Search catalogs, brands
  static const catalogSearch = '$refashionedBaseUrl/catalog/search/?q=';

  //Maps
  static const pickPoints = '$refashionedBaseUrl/pickpoints';

  //Authorization
  static const authorization = '$refashionedBaseUrl/users/authorization/';
  static String codeAuthorization(String phone, String hash) =>
      '$authorization' + phone + '_' + hash + '/';

  //Favourites
  static const wished = '$refashionedBaseUrl/catalog/wished/';
  static const wishedProducts = '$refashionedBaseUrl/catalog/wished/products';

  //Size table
  static String sizes(id) => '$refashionedBaseUrl/catalog/categories/' + id + '/sizes/';

  //Home
  static const home = '$refashionedBaseUrl/main-page/';

  //Profile
  static const profileProducts = '$refashionedBaseUrl/users/profile/products/';

  //onboarding

  static const onboarding = '$refashionedBaseUrl/content/onboarding/';

}
