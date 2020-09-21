import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/repositories/quick_filters.dart';
import 'package:refashioned_app/repositories/sort_methods.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_button.dart';
import 'package:refashioned_app/screens/catalog/sorting/components/sorting_button.dart';
import 'package:refashioned_app/screens/products/components/products_title.dart';
import 'package:refashioned_app/screens/products/components/quick_filter_list.dart';
import 'package:refashioned_app/screens/products/content/products.dart';

class ProductsPage extends StatefulWidget {
  final Function(Product, {dynamic callback}) onPush;
  final Category topCategory;
  final SearchResult searchResult;

  final String parameters;
  final String title;

  const ProductsPage(
      {Key key, this.onPush, this.topCategory, this.searchResult, this.parameters, this.title});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FiltersRepository filtersRepository;
  SortMethodsRepository sortMethodsRepository;
  CategoryBrandsRepository categoryBrandsRepository;
  QuickFiltersRepository quickFiltersRepository;

  String initialParameters;

  List<Category> quickFiltersCategories;
  List<Brand> selectedBrands;

  @override
  void initState() {
    filtersRepository = FiltersRepository();
    sortMethodsRepository = SortMethodsRepository();

    categoryBrandsRepository = Provider.of<CategoryBrandsRepository>(context, listen: false);

    filtersRepository.addListener(repositoryListener);
    sortMethodsRepository.addListener(repositoryListener);

    filtersRepository.getFilters();
    sortMethodsRepository.getSortMethods();

    if (widget.searchResult != null) {
      initialParameters = "?p=" + widget.searchResult.id;
    } else if (widget.parameters != null) {
      initialParameters = widget.parameters;
    } else if (categoryBrandsRepository.response != null && categoryBrandsRepository.isLoaded) {
      initialParameters = widget.topCategory.getRequestParameters();
      initialParameters += categoryBrandsRepository.getRequestParameters();
      quickFiltersCategories = List()
        ..addAll(widget.topCategory.children.map((e) => Category.clone(e)).toList());
      selectedBrands = categoryBrandsRepository.response.content.where((element) => element.selected).toList();
    } else {
      initialParameters = widget.topCategory.getRequestParameters();
      quickFiltersCategories = List()
        ..addAll(widget.topCategory.children.map((e) => Category.clone(e)).toList());
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

  updateProducts(BuildContext context, {bool updateFromQuickFilters = false}) {
    syncFilters(updateFromQuickFilters);

    if (quickFiltersCategories != null)
      initialParameters = "?p=" +
          (quickFiltersCategories.where((category) => category.selected).isNotEmpty
              ? quickFiltersCategories
                  .where((category) => category.selected)
                  .map((category) => category.id)
                  .join(',')
              : widget.topCategory.id);
    else if (widget.topCategory != null)
      initialParameters = widget.topCategory.getRequestParameters();

    final quickFiltersParameters = quickFiltersRepository.getRequestParameters();

    final filtersParameters = filtersRepository.isLoaded && filtersRepository.getStatusCode == 200
        ? filtersRepository.response.content
            .fold("", (parameters, filter) => parameters + filter.getRequestParameters())
        : "";

    final sortParameters =
        sortMethodsRepository.isLoaded && sortMethodsRepository.getStatusCode == 200
            ? sortMethodsRepository.response.content.getRequestParameters()
            : "";

    String newParameters =
        initialParameters + filtersParameters + sortParameters + quickFiltersParameters;

    Provider.of<ProductsRepository>(context, listen: false).getProducts(newParameters);
  }

  //TODO: refactor method sync filters
  void syncFilters(bool updateFromQuickFilters) {
    if (filtersRepository.isLoaded && quickFiltersRepository.isLoaded) {
      var selectedFilters = Set<String>();
      if (updateFromQuickFilters) {
        selectedFilters.addAll(quickFiltersRepository.response.content
            .where((element) => element.selected)
            .map((e) => e.values.id));
      } else {
        filtersRepository.response.content.forEach((element) {
          if (element.values != null)
            selectedFilters
                .addAll(element.values.where((element) => element.selected).map((e) => e.id));
        });
      }
      quickFiltersRepository.response.content.forEach((element) {
        if (selectedFilters.contains(element.values.id))
          element.selected = true;
        else
          element.selected = false;
      });
      filtersRepository.response.content.forEach((element) {
        if (element.values != null)
          element.values.forEach((element) {
            if (selectedFilters.contains(element.id))
              element.selected = true;
            else
              element.selected = false;
          });
      });

      quickFiltersRepository.response.content.forEach((element) {
        if (element.values.price != null && element.selected) {}
      });

      Future.delayed(Duration.zero, () {
        quickFiltersRepository.finishLoading();
      });
    }

    if (selectedBrands != null && filtersRepository.isLoaded) {
      selectedBrands
          .where((element) => element.selected)
          .forEach((element) {
        filtersRepository.response.content
            .where((filter) => filter.parameter == Parameter.brand)
            .forEach((filter) {
          filter.values.firstWhere((filterValue) => filterValue.id == element.id).selected = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductsRepository>(
              create: (_) => ProductsRepository()..getProducts(initialParameters)),
          ChangeNotifierProvider(create: (_) => QuickFiltersRepository()..getQuickFilters())
        ],
        builder: (context, _) {
          quickFiltersRepository = Provider.of<QuickFiltersRepository>(context, listen: false);
          syncFilters(false);
          return (filtersRepository.isLoaded && sortMethodsRepository.isLoaded)
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: QuickFilterList(
                          topCategory: widget.topCategory,
                          categories: quickFiltersCategories,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          updateProducts: ({categories}) =>
                              updateProducts(context, updateFromQuickFilters: true)),
                    ),
                    ProductsTitle(
                        categoryName: (widget.searchResult != null)
                            ? widget.searchResult.name
                            : (widget.title != null) ? widget.title : widget.topCategory.name),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 15, 8),
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
                        onPush: (product) {
                          widget.onPush(
                            product,
                            callback: () {
                              updateProducts(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : SizedBox();
        },
      ),
    );
  }
}
