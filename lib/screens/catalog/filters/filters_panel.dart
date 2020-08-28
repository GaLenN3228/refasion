import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FiltersPanel extends StatefulWidget {
  final String root;
  final List<Filter> filters;
  final Function() updateProducts;
  final ScrollController scrollController;

  const FiltersPanel(
      {Key key,
      this.filters,
      this.updateProducts,
      this.root,
      this.scrollController})
      : super(key: key);

  @override
  _FiltersPanelState createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  String countParameters;

  @override
  void initState() {
    countParameters = getParameters(widget.filters);

    widget.scrollController.addListener(scrollControllerListener);

    super.initState();
  }

  scrollControllerListener() => FocusScope.of(context).unfocus();

  @override
  dispose() {
    widget.scrollController?.removeListener(scrollControllerListener);

    super.dispose();
  }

  String getParameters(List<Filter> filters) => filters.fold(widget.root,
      (parameters, filter) => parameters + filter.getRequestParameters());

  updateCount(BuildContext context) async {
    setState(() {
      countParameters = getParameters(widget.filters);
    });

    Provider.of<ProductsCountRepository>(context, listen: false)
        .getProductsCount(countParameters);
  }

  resetFilters(BuildContext context) async {
    setState(() {
      widget.filters.forEach((filter) => filter.reset());

      countParameters = widget.root;
    });

    Provider.of<ProductsCountRepository>(context, listen: false)
        .getProductsCount(countParameters);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductsCountRepository>(
      create: (_) {
        return ProductsCountRepository()..getProductsCount(countParameters);
      },
      builder: (context, _) {
        return Stack(
          children: [
            SafeArea(
              child: Material(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    FiltersTitle(
                      onClose: () {
                        widget.filters.forEach(
                            (filter) => filter.reset(toPrevious: true));
                      },
                      onReset: () => resetFilters(context),
                      canReset: widget.filters
                          .where((filter) => filter.modified)
                          .isNotEmpty,
                    ),
                    Expanded(
                      child: ListView(
                        children: widget.filters
                            .asMap()
                            .entries
                            .map(
                              (entry) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry.key != 0) ItemsDivider(),
                                  FilterTile(
                                      filter: entry.value,
                                      onUpdate: () => updateCount(context)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  final productCountRepository =
                      context.watch<ProductsCountRepository>();

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
                    subtitle = productCountRepository
                        .response.content.getCountText;
                  }
                  return BottomButton(
                    action: () {
                      widget.filters.forEach((filter) => filter.save());

                      if (widget.updateProducts != null)
                        widget.updateProducts();

                      Navigator.of(context).pop();
                    },
                    title: title,
                    subtitle: subtitle,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
