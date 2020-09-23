import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';
import 'package:refashioned_app/utils/colors.dart';

class FiltersPanel extends StatefulWidget {
  final String root;
  final Function() updateProducts;
  final ScrollController scrollController;
  final String categoryId;

  const FiltersPanel(
      {Key key, this.updateProducts, this.root, this.scrollController, this.categoryId})
      : super(key: key);

  @override
  _FiltersPanelState createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  String countParameters;
  FiltersRepository filtersRepository;

  @override
  void initState() {
    filtersRepository = Provider.of<FiltersRepository>(context, listen: false);
    //TODO refactor, change id to parent category id, need changes on db side
    filtersRepository.getFilters(widget.categoryId);

    widget.scrollController.addListener(scrollControllerListener);

    super.initState();
  }

  scrollControllerListener() => FocusScope.of(context).unfocus();

  @override
  dispose() {
    widget.scrollController?.removeListener(scrollControllerListener);

    super.dispose();
  }

  String getParameters(List<Filter> filters) =>
      filters.fold(widget.root, (parameters, filter) => parameters + filter.getRequestParameters());

  updateCount(BuildContext context) async {
    setState(() {
      countParameters = getParameters(filtersRepository.response.content);
    });

    Provider.of<ProductsCountRepository>(context, listen: false).getProductsCount(countParameters);
  }

  resetFilters(BuildContext context) async {
    setState(() {
      filtersRepository.response.content.forEach((filter) => filter.reset());

      countParameters = widget.root;
    });

    Provider.of<ProductsCountRepository>(context, listen: false).getProductsCount(countParameters);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FiltersRepository>();
    if (filtersRepository.isLoading)
      return Center(
          child: SizedBox(
        height: 32.0,
        width: 32.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: accentColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ));

    if (filtersRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    if (filtersRepository.isLoaded){
      countParameters = getParameters(filtersRepository.response.content);
    }

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
                        filtersRepository.response.content
                            .forEach((filter) => filter.reset(toPrevious: true));
                      },
                      onReset: () => resetFilters(context),
                      canReset: filtersRepository.response.content
                          .where((filter) => filter.modified)
                          .isNotEmpty,
                    ),
                    Expanded(
                      child: ListView(
                        children: filtersRepository.response.content
                            .asMap()
                            .entries
                            .map(
                              (entry) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry.key != 0) ItemsDivider(),
                                  FilterTile(
                                      filter: entry.value, onUpdate: () => updateCount(context)),
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
                      filtersRepository.response.content.forEach((filter) => filter.save());

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
        );
      },
    );
  }
}
