class Url {
  //Base URLs
  static const refashionedBaseUrl = 'https://api.refashioned.ru/v1';

  //Categories
  static const categories = '$refashionedBaseUrl/catalog/categories/';

  //Products
  static const products = '$refashionedBaseUrl/catalog/products/';
  static const productsCount = '$refashionedBaseUrl/catalog/products/count/';

  //Filters
  static const filters = '$refashionedBaseUrl/catalog/filters/';

  //Content
  static const catalogMenu = '$refashionedBaseUrl/content/catalog-menu/';

  //Search
  static const search = '$refashionedBaseUrl/catalog/search/';

  //Cart Demo
  static const cart ='https://itlessons.ru/assets/refashioned-cart.json';

  //Search catalogs, brands
  static const catalogSearch = '$refashionedBaseUrl/catalog/search/?q=';
}
