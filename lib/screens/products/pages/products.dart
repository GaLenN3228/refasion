import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/components/filters_wrap.dart';
import 'package:refashioned_app/screens/products/content/products.dart';

class ProductsPage extends StatelessWidget {
  //TODO доделать каунтер на фильтр
  final Function(Product) onPush;
  final Function() onPop;

  final String id;

  const ProductsPage({Key key, this.onPush, this.onPop, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsRepository>(
      create: (_) => ProductsRepository(id: id),
      child: FiltersWrap(
        onPop: onPop,
        child: ProductsPageContent(
          onPush: onPush,
        ),
      ),
    );
  }
}
