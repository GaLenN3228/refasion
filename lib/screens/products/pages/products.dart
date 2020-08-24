import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/favourites.dart';
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
  final Category topCategory;
  final SearchResult searchResult;

  const ProductsPage({Key key, this.onPush, this.onSearch, this.topCategory, this.searchResult});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FiltersRepository filtersRepository;
  SortMethodsRepository sortMethodsRepository;

  String initialParameters;

  @override
  void initState() {
    filtersRepository = FiltersRepository();
    sortMethodsRepository = SortMethodsRepository();

    filtersRepository.addListener(repositoryListener);
    sortMethodsRepository.addListener(repositoryListener);

    filtersRepository.getFilters();
    sortMethodsRepository.getSortMethods();

    if (widget.searchResult != null) {
      initialParameters = "?p=" + widget.searchResult.id;
    } else {
      initialParameters = widget.topCategory.getRequestParameters();
    }

    super.initState();
  }

  @override
  dispose() {
    filtersRepository.removeListener(repositoryListener);
    sortMethodsRepository.removeListener(repositoryListener);

    super.dispose();
  }

  repositoryListener() => setState(() {});

  updateProducts(BuildContext context) {
    if (widget.topCategory != null) initialParameters = widget.topCategory.getRequestParameters();

    final quickFiltersRepository = Provider.of<QuickFiltersRepository>(context, listen: false);
    final quickFiltersParameters = quickFiltersRepository.getRequestParameters();

    final filtersParameters = filtersRepository.isLoaded && filtersRepository.getStatusCode == 200
        ? filtersRepository.response.content
            .fold("", (parameters, filter) => parameters + filter.getRequestParameters())
        : "";

    final sortParameters = sortMethodsRepository.isLoaded && sortMethodsRepository.getStatusCode == 200
        ? sortMethodsRepository.response.content.getRequestParameters()
        : "";

    String newParameters = initialParameters + filtersParameters + sortParameters + quickFiltersParameters;

    Provider.of<ProductsRepository>(context, listen: false).getProducts(newParameters);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductsRepository>(
                create: (_) =>
                    ProductsRepository()..getProducts(initialParameters)),
            ChangeNotifierProvider(create: (_) => QuickFiltersRepository()..getQuickFilters())
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
                      filtersRepository.getStatusCode.toString(),
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
                      filtersRepository.getStatusCode.toString(),
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
                    topCategory: widget.topCategory,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    updateProducts: () => updateProducts(context)),
                ProductsTitle(
                    categoryName: widget.searchResult != null ? widget.searchResult.name : widget.topCategory.name),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FiltersButton(
                        root: initialParameters,
                        filters: filtersRepository.response.content,
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
