import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/city_selector/city_tile.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';

class CitiesList extends StatefulWidget {
  final CitiesProvider citiesProvider;
  final ValueNotifier<bool> isScrolled;
  final Function() onSelect;
  final TBSearchController searchController;

  const CitiesList(
      {Key key,
      this.citiesProvider,
      this.isScrolled,
      this.onSelect,
      this.searchController})
      : assert(citiesProvider != null);

  @override
  _CitiesListState createState() => _CitiesListState();
}

class _CitiesListState extends State<CitiesList> {
  ScrollController scrollController;
  bool isScrolled;

  @override
  void initState() {
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);

    super.initState();
  }

  scrollListener() {
    final newIsScrolled =
        scrollController.offset > scrollController.position.minScrollExtent;

    if (widget.isScrolled != null) widget.isScrolled.value = newIsScrolled;

    if (!newIsScrolled)
      widget.searchController?.focus();
    else
      widget.searchController?.unfocus();

    isScrolled = newIsScrolled;
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<City>>(
      stream: widget.citiesProvider.cities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text(
            "Загрузка городов",
            style: Theme.of(context).textTheme.bodyText1,
          );

        if (!snapshot.hasData)
          return Text(
            "Городов нет",
            style: Theme.of(context).textTheme.bodyText1,
          );

        if (snapshot.hasError)
          return Text(
            "Ошибка при загрузка городов: " + snapshot.error.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          );

        final pinnedCount = widget.citiesProvider.pinnedCount;

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.only(
              top: 10, bottom: MediaQuery.of(context).padding.bottom),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            final city = snapshot.data.elementAt(index);

            return CityTile(
              city: city,
              onTap: () {
                widget.citiesProvider.select(city);
                if (widget.onSelect != null) widget.onSelect();
              },
            );
          },
          separatorBuilder: (context, index) => index != pinnedCount - 1
              ? CategoryDivider()
              : Container(
                  height: 8,
                  width: double.infinity,
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
        );
      },
    );
  }
}
