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

class CitySelectorPage extends StatelessWidget {
  final CitiesRepository citiesRepository;

  final isScrolled = ValueNotifier<bool>(false);
  final searchController = TBSearchController();

  CitySelectorPage({@required this.citiesRepository})
      : assert(citiesRepository != null);

  Future<void> setCityId(String id) async => SharedPreferences.getInstance()
      .then((prefs) => prefs.setString("city_id", id));

  @override
  Widget build(BuildContext context) {
    final citiesProvider = citiesRepository.citiesResponse.content;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          TopBar(
            searchController: searchController,
            leftButtonType: TBButtonType.none,
            middleType: TBMiddleType.text,
            middleText: "Выбор города",
            rightButtonType: TBButtonType.none,
            bottomType: TBBottomType.search,
            searchHintText: "Город или регион",
            onSearchUpdate: citiesProvider.search,
            autofocus: true,
            isElevated: isScrolled,
          ),
          Expanded(
            child: CitiesList(
              searchController: searchController,
              citiesProvider: citiesProvider,
              isScrolled: isScrolled,
              onSelect: () {
                citiesRepository
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
