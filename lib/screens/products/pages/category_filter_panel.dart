import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product_count.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/products/components/category_filter_list.dart';
import 'package:refashioned_app/screens/products/components/category_filter_panel_title.dart';

class CategoryFilterPanel extends StatefulWidget {
  final Function() updateProducts;
  final Category topCategory;

  const CategoryFilterPanel({Key key, this.updateProducts, this.topCategory}) : super(key: key);

  @override
  _CategoryFilterPanelState createState() => _CategoryFilterPanelState();
}

class _CategoryFilterPanelState extends State<CategoryFilterPanel> {
  List<Category> savedCategories;
  String categoryFiltersParameters;

  prepareParameters() {
    final selectedIdList =
        widget.topCategory.children.where((category) => category.selected).map((category) => category.id);
    if (selectedIdList.isNotEmpty)
      categoryFiltersParameters = "?p=" + selectedIdList.join(',');
    else
      categoryFiltersParameters = "?p=" + widget.topCategory.id;
  }

  onReset(BuildContext context) {
    setState(() {
      widget.topCategory.children.forEach((category) => category.reset());
    });
    prepareParameters();
    updateCount(context);
  }

  onClose(BuildContext context) {
    widget.topCategory.children
      ..clear()
      ..addAll(savedCategories);
  }

  updateCategory(BuildContext context, {String id}) {
    if (id != null && id.isNotEmpty) widget.topCategory.children.firstWhere((category) => category.id == id).update();
    prepareParameters();
    updateCount(context);
  }

  updateCount(BuildContext context) {
    Provider.of<ProductCountRepository>(context, listen: false).update(newParameters: categoryFiltersParameters);
  }

  @override
  void initState() {
    savedCategories = List()..addAll(widget.topCategory.children.map((e) => Category.clone(e)).toList());
    prepareParameters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCountRepository>(create: (_) {
      return ProductCountRepository(parameters: categoryFiltersParameters);
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
                        values: widget.topCategory.children,
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
                    final productCountRepository = context.watch<ProductCountRepository>();

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
                      subtitle = productCountRepository.productsCountResponse.productsCount.text;
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
