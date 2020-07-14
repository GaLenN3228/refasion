import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_button.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_button.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/products/content/products.dart';

class ProductsPage extends StatelessWidget {
  //TODO доделать каунтер на фильтр
  final Function(Product) onPush;
  final Function() onPop;
  final Function() hideTabBar;
  final Function() showTabBar;

  final String id;

  const ProductsPage(
      {Key key,
      this.onPush,
      this.onPop,
      this.id,
      this.hideTabBar,
      this.showTabBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsRepository>(
        create: (_) => ProductsRepository(id),
        child: Column(
          children: [
            TopPanel(
              canPop: true,
              onPop: onPop,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [FiltersButton(), SortingButton()],
              ),
            ),
            Expanded(
              child: ProductsPageContent(
                onPush: onPush,
              ),
            ),
          ],
        ));
  }
}
