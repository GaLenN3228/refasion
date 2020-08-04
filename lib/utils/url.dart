class Url {
  //Base URLs
  static const refashionedBaseUrl = 'https://api.refashioned.ru/v1';

  //Categories
  static const categories = '$refashionedBaseUrl/catalog/categories/';

  //Products
  static const products = '$refashionedBaseUrl/catalog/products/';
  static const productsCount = '$refashionedBaseUrl/catalog/products/count/';

  //SellProperties
  static const properties = '$refashionedBaseUrl/catalog/properties/';

  //Filters
  static const filters = '$refashionedBaseUrl/catalog/filters/';
  static const quick_filters = '$refashionedBaseUrl/catalog/quickfilters/';

  //Content
  static const catalogMenu = '$refashionedBaseUrl/content/catalog-menu/';

  //Search
  static const search = '$refashionedBaseUrl/catalog/search/';

  //Cart
  static const cart_demo ='https://itlessons.ru/assets/refashioned-cart.json';
  static const cartItem ='$refashionedBaseUrl/cart/item/';
  static const cart ='$refashionedBaseUrl/cart/';

  //Search catalogs, brands
  static const catalogSearch = '$refashionedBaseUrl/catalog/search/?q=';
}
