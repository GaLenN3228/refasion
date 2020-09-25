import 'package:refashioned_app/models/product.dart';

class HomeContent {
  final List<HomeBlock> blocks;

  const HomeContent({this.blocks});

  factory HomeContent.fromJson(Map<String, dynamic> json) {
    return HomeContent(blocks: [
      if (json['blocks'] != null)
        for (final block in json['blocks']) HomeBlock.fromJson(block)
    ]);
  }
}

class HomeBlock {
  final String name;
  final String type;
  final List<HomeBlockItem> items;

  const HomeBlock({this.name, this.type, this.items});

  factory HomeBlock.fromJson(Map<String, dynamic> json) {
    return HomeBlock(name: json['name'], type: json['type'], items: [
      if (json['items'] != null)
        for (final item in json['items']) HomeBlockItem.fromJson(item)
    ]);
  }
}

class HomeBlockItem {
  final String name;
  final String image;
  final String id;
  final String url;
  final List<Product> products;

  const HomeBlockItem({this.name, this.image, this.id, this.url, this.products});

  factory HomeBlockItem.fromJson(Map<String, dynamic> json) {
    return HomeBlockItem(
        name: json['name'],
        image: json['image'],
        id: json['id'],
        url: json['url'],
        products: [
          if (json['products'] != null)
            for (final product in json['products']) Product.fromJson(product)
        ]);
  }
}
