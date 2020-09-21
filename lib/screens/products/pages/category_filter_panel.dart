import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/products/components/category_filter_list.dart';
import 'package:refashioned_app/screens/products/components/category_filter_panel_title.dart';

class CategoryFilterPanel extends StatefulWidget {
  final Function() updateProducts;
  final List<Category> categories;
  final Category topCategory;

  const CategoryFilterPanel({Key key, this.updateProducts, this.topCategory, this.categories}) : super(key: key);

  @override
  _CategoryFilterPanelState createState() => _CategoryFilterPanelState();
}

class _CategoryFilterPanelState extends State<CategoryFilterPanel> {
  String categoryFiltersParameters;

  prepareParameters() {
    final selectedIdList =
    widget.categories.where((category) => category.selected).map((category) => category.id);
    if (selectedIdList.isNotEmpty)
      categoryFiltersParameters = "?p=" + selectedIdList.join(',');
    else
      categoryFiltersParameters = "?p=" + widget.topCategory.id;
  }

  onReset(BuildContext context) {
    setState(() {
      widget.categories.forEach((category) => category.reset());
    });
    prepareParameters();
    updateCount(context);
  }

  onClose(BuildContext context) {
    // widget.topCategory.children
    //   ..clear()
    //   ..addAll(savedCategories);
  }

  updateCategory(BuildContext context, {String id}) {
    if (id != null && id.isNotEmpty) widget.categories.firstWhere((category) => category.id == id).update();
    prepareParameters();
    updateCount(context);
  }

  updateCount(BuildContext context) {
    Provider.of<ProductsCountRepository>(context, listen: false).getProductsCount(categoryFiltersParameters);
  }

  @override
  void initState() {
    prepareParameters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsCountRepository>(create: (_) {
      return ProductsCountRepository()..getProductsCount(categoryFiltersParameters);
    }, builder: (context, _) {
      return WillPopScope(
          onWillPop: () async {
            onClose(context);
            return true;
          },
          child: Stack(
            children: [
              Material(
                color: Colors.white,
                child: Column(
                  children: [
                    CategoryFilterPanelTitle(
                      onClose: () => onClose(context),
                      categoryName: widget.topCategory.name,
                      onReset: () => onReset(context),
                    ),
                    Expanded(
                      child: CategoryFilterList(
                        values: widget.categories,
                        onSelect: (id) {
                          setState(() {
                            updateCategory(context, id: id);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Builder(
                  builder: (context) {
                    final productCountRepository = context.watch<ProductsCountRepository>();

                    String title = "";
                    String subtitle = "";

                    if (productCountRepository.isLoading) {
                      title = "ПОДОЖДИТЕ";
                      subtitle = "Обновление товаров...";
                    } else if (productCountRepository.loadingFailed) {
                      title = "ОШИБКА";
                      subtitle = "Мы уже работаем над её исправлением";
                    } else {
                      title = "ПОКАЗАТЬ";
                      subtitle = productCountRepository.response.content.getCountText;
                    }
                    return BottomButton(
                      action: () {
                        if (widget.updateProducts != null) widget.updateProducts();
                        Navigator.of(context).pop();
                      },
                      title: title,
                      subtitle: subtitle,
                    );
                  },
                ),
              ),
            ],
          ));
    });
  }
}
