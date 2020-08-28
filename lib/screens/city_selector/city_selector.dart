import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/city_selector/city_tile.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';
import 'package:refashioned_app/screens/components/scaffold/scaffold.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/components/tab_switcher/tab_switcher.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitySelector extends StatefulWidget {
  const CitySelector();

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  CitiesRepository citiesRepository;
  ValueNotifier<Status> statusNotifier;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    statusNotifier = ValueNotifier(Status.loading);

    citiesRepository = Provider.of<CitiesRepository>(context, listen: false);

    citiesRepository.statusNotifier.addListener(citiesRepositoryStatusListener);

    super.initState();
  }

  citiesRepositoryStatusListener() async {
    final repositoryStatus = citiesRepository.statusNotifier.value;
    switch (repositoryStatus) {
      case Status.error:
        print("bypassing city check error");
        pushTabSwitcher();
        break;

      case Status.loading:
        statusNotifier.value = repositoryStatus;
        break;

      case Status.loaded:
        await SharedPreferences.getInstance().then((newSharedPreferences) {
          sharedPreferences = newSharedPreferences;
          if (sharedPreferences.containsKey(Prefs.city_id)) {
            bool check = false;
            try {
              final cityId = sharedPreferences.getString(Prefs.city_id);
              check = citiesRepository.response.content
                  .checkSavedCity(cityId);
            } catch (err) {
              print("City Check Exception: " + err.toString());
            }
            if (check)
              pushTabSwitcher();
            else
              statusNotifier.value = repositoryStatus;
          } else
            statusNotifier.value = repositoryStatus;
        }).catchError((err) {
          print("Shared Prefs Exception: " + err.toString());
          statusNotifier.value = Status.error;
        });
        break;
    }
  }

  selectCity() {
    citiesRepository
        .selectCity(citiesRepository.response.content.selectedCity)
        .then((newCity) {
      if (newCity != null)
        setCityId(newCity.id).then((result) {
          if (result)
            pushTabSwitcher();
          else
            print("city wasn't selected");
        });
      else
        print("city wasn't provided");
    });
  }

  Future<bool> setCityId(String id) async =>
      sharedPreferences?.setString(Prefs.city_id, id);

  pushTabSwitcher() => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: TabSwitcher(),
          ),
        ),
      );

  @override
  void dispose() {
    citiesRepository.statusNotifier
        .removeListener(citiesRepositoryStatusListener);

    citiesRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefashionedScaffold(
      state: statusNotifier,
      stateData: {
        Status.error: () => ScaffoldData.simple(
              adjustToOverlays: false,
              childrenData: ScaffoldChildrenData.logo(),
            ),
        Status.loading: () => ScaffoldData.simple(
              adjustToOverlays: false,
              childrenData: ScaffoldChildrenData.logo(),
            ),
        Status.loaded: () {
          final citiesProvider = citiesRepository.response.content;

          return ScaffoldData(
            topBarData: TopBarData(
              middleData: TBMiddleData.title("Выбор города"),
              searchData: TBSearchData(
                hintText: "Город или регион",
                onSearchUpdate: citiesProvider.search,
                autofocus: true,
              ),
            ),
            childrenDataStream: citiesProvider.cities.map(
              (cities) => ScaffoldChildrenData(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities.elementAt(index);
                  return CityTile(
                    city: city,
                    onTap: () {
                      citiesProvider.select(city);
                      selectCity();
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    index != citiesProvider.pinnedCount - 1
                        ? ItemsDivider()
                        : Container(
                            height: 8,
                            width: double.infinity,
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                          ),
              ),
            ),
          );
        },
      },
    );
  }
}
