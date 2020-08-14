import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/city_selector/cities_list.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_search.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitySelectorPage extends StatefulWidget {
  final CitiesRepository citiesRepository;

  CitySelectorPage({@required this.citiesRepository})
      : assert(citiesRepository != null);

  @override
  _CitySelectorPageState createState() => _CitySelectorPageState();
}

class _CitySelectorPageState extends State<CitySelectorPage> {
  ScrollController scrollController;
  TBSearchController searchController;

  @override
  void initState() {
    scrollController = ScrollController();

    searchController = TBSearchController();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  Future<void> setCityId(String id) async => SharedPreferences.getInstance()
      .then((prefs) => prefs.setString("city_id", id));

  @override
  Widget build(BuildContext context) {
    final citiesProvider = widget.citiesRepository.citiesResponse.content;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          RefashionedTopBar(
            searchController: searchController,
            leftButtonType: TBButtonType.none,
            middleType: TBMiddleType.title,
            middleTitleText: "Выбор города",
            rightButtonType: TBButtonType.none,
            bottomType: TBBottomType.search,
            searchHintText: "Город или регион",
            onSearchUpdate: citiesProvider.search,
            autofocus: true,
            scrollController: scrollController,
          ),
          Expanded(
            child: CitiesList(
              searchController: searchController,
              citiesProvider: citiesProvider,
              scrollController: scrollController,
              onSelect: () {
                widget.citiesRepository
                    .selectCity(citiesProvider.selectedCity)
                    .then((newCity) {
                  if (newCity != null)
                    return setCityId(newCity.id).then((_) =>
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false));
                  else
                    print("null city received");
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
