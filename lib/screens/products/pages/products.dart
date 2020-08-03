import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_button.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_button.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:refashioned_app/screens/products/components/products_title.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_list.dart';
import 'package:refashioned_app/screens/products/content/products.dart';

class ProductsPage extends StatefulWidget {
  final Function(Product) onPush;
  final Function() onSearch;
  final String id;
  final String categoryName;
  final Function() onUpdate;
  final List<Category> categories;

  const ProductsPage({Key key, this.onPush, this.id, this.onSearch, this.categoryName, this.onUpdate, this.categories})
      : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String productsParameters;

  @override
  void initState() {
    productsParameters = "?p=" + widget.id;

    super.initState();
  }

  updateProducts(BuildContext context, String newParameters) {
    productsParameters = newParameters;

    Provider.of<ProductsRepository>(context, listen: false).update(newParameters: productsParameters);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductsRepository>(create: (_) => ProductsRepository(parameters: productsParameters)),
          ChangeNotifierProvider(create: (_) => QuickFiltersRepository())
        ],
        child: Column(
          children: [
            TopPanel(
              canPop: true,
              onSearch: widget.onSearch,
            ),
            QuickFilterList(
                onUpdate: widget.onUpdate,
                categoryName: widget.categoryName,
                categories: widget.categories,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                updateProducts: (parameters) => updateProducts(context, parameters)),
            ProductsTitle(categoryName: widget.categoryName),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FiltersButton(
                    root: widget.id,
                    updateProducts: (parameters) => updateProducts(context, parameters),
                  ),
                  SortingButton()
                ],
              ),
            ),
            Expanded(
              child: ProductsPageContent(
                onPush: widget.onPush,
              ),
            ),
          ],
        ));
  }
}
