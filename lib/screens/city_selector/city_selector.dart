import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/authorization/phone_page.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/city_selector/city_tile.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_image.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/components/tab_switcher/tab_switcher.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/onbording/on_bording.dart';

class CitySelector extends StatefulWidget {
  final bool onFirstLaunch;

  const CitySelector({Key key, this.onFirstLaunch: false}) : super(key: key);

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  CitiesRepository citiesRepository;

  bool skipable = false;

  @override
  initState() {
    super.initState();

    citiesRepository = Provider.of<CitiesRepository>(context, listen: false);

    if (widget.onFirstLaunch) citiesRepository.addListener(repositoryListener);
  }

  repositoryListener() {
    skipable = (citiesRepository.response?.content?.skipable ?? false) && widget.onFirstLaunch;

    if (skipable) {
      citiesRepository.removeListener(repositoryListener);

      push(OnbordingPage());
    }
  }

  @override
  dispose() {
    citiesRepository.removeListener(repositoryListener);

    super.dispose();
  }

  push(Widget widget, {BuildContext context}) =>
      Navigator.of(context ?? this.context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => widget,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      child: Consumer<CitiesRepository>(
        builder: (context, repository, emptyState) {
          if (repository.loadingFailed)
            return Center(
              child: Text(
                "Ошибка: " + repository.response?.errors.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );

          final provider = repository.response?.content;

          if (repository.isLoading || provider == null || skipable) return emptyState;

          return Column(
            children: [
              RefashionedTopBar(
                data: TopBarData(
                  leftButtonData: widget.onFirstLaunch
                      ? null
                      : TBButtonData.icon(
                          TBIconType.back,
                          onTap: Navigator.of(context).pop,
                        ),
                  middleData: TBMiddleData.title("Выбор города"),
                  searchData: TBSearchData(
                    hintText: "Город или регион",
                    onSearchUpdate: provider.search,
                    autofocus: true,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<City>>(
                    stream: provider.cities,
                    builder: (context, snapshot) {
                      final cities = snapshot?.data;

                      if (cities == null || cities.isEmpty)
                        return Text(
                          "Введите название города",
                          style: Theme.of(context).textTheme.subtitle2,
                        );

                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                        itemCount: cities.length,
                        itemBuilder: (context, index) {
                          final city = cities.elementAt(index);

                          return CityTile(
                            city: city,
                            onTap: () async {
                              final result = await repository.selectCity(city);

                              if (result) {
                                if (widget.onFirstLaunch)
                                  Future.delayed(Duration(milliseconds: 200), () {
                                    push(PhonePage(
                                      needDismiss: false,
                                      onAuthorizationDone: (context) {
                                        push(TabSwitcher(), context: context);
                                      },
                                      onAuthorizationCancel: (context) {
                                        push(TabSwitcher(), context: context);
                                      },
                                    ));
                                  });
                                else
                                  Navigator.of(context).pop();
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => index != provider.pinnedCount - 1
                            ? ItemsDivider()
                            : Container(
                                height: 8,
                                width: double.infinity,
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                              ),
                      );
                    }),
              ),
            ],
          );
        },
        child: Center(
          child: widget.onFirstLaunch
              ? SVGImage(
                  image: ImageAsset.refashionedLogo,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
