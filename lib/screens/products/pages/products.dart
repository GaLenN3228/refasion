import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/repositories/sort_methods.dart';
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

  const ProductsPage(
      {Key key,
      this.onPush,
      this.id,
      this.onSearch,
      this.categoryName,
      this.onUpdate,
      this.categories});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FiltersRepository filtersRepository;
  SortMethodsRepository sortMethodsRepository;

  String root;

  @override
  void initState() {
    filtersRepository = FiltersRepository();
    sortMethodsRepository = SortMethodsRepository();

    filtersRepository.addListener(repositoryListener);
    sortMethodsRepository.addListener(repositoryListener);

    root = "?p=" + widget.id;

    super.initState();
  }

  @override
  dispose() {
    filtersRepository.removeListener(repositoryListener);
    sortMethodsRepository.removeListener(repositoryListener);

    super.dispose();
  }

  repositoryListener() => setState(() {});

  String getParameters() {
    final filtersParameters = filtersRepository.isLoaded &&
            filtersRepository.filtersResponse.status.code == 200
        ? filtersRepository.filtersResponse.content.fold("",
            (parameters, filter) => parameters + filter.getRequestParameters())
        : "";

    final sortParameters = sortMethodsRepository.isLoaded &&
            sortMethodsRepository.response.status.code == 200
        ? sortMethodsRepository.response.content.getRequestParameters()
        : "";

    return root + filtersParameters + sortParameters;
  }

  updateProducts(BuildContext context) {
    final newParameters = getParameters();

    Provider.of<ProductsRepository>(context, listen: false)
        .update(newParameters: newParameters);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductsRepository>(
                create: (_) => ProductsRepository(parameters: root)),
            ChangeNotifierProvider(create: (_) => QuickFiltersRepository())
          ],
          builder: (context, _) {
            if (filtersRepository.isLoading)
              return Center(
                child: Text(
                  "Загружаем фильтры...",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );

            if (filtersRepository.loadingFailed)
              return Center(
                child: Text(
                  "Ошибка при загрузке фильтров. Статус " +
                      filtersRepository.filtersResponse.status.code.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );

            if (sortMethodsRepository.isLoading)
              return Center(
                child: Text(
                  "Загружаем методы сортировки...",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );

            if (sortMethodsRepository.loadingFailed)
              return Center(
                child: Text(
                  "Ошибка при загрузке методов сортировки. Статус " +
                      filtersRepository.filtersResponse.status.code.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );

            return Column(
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
                    updateProducts: (parameters) => updateProducts(context)),
                ProductsTitle(categoryName: widget.categoryName),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FiltersButton(
                        root: root,
                        filters: filtersRepository.filtersResponse.content,
                        onApply: () => updateProducts(context),
                      ),
                      SortingButton(
                        sort: sortMethodsRepository.response.content,
                        onUpdate: () => updateProducts(context),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ProductsPageContent(
                    onPush: widget.onPush,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
