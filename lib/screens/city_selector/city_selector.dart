import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
import 'package:refashioned_app/utils/colors.dart';

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

      push(TabSwitcher());
    }

  }

  @override
  dispose() {
    citiesRepository.removeListener(repositoryListener);

    super.dispose();
  }

  push(Widget widget, {BuildContext context}) => Navigator.of(context ?? this.context).pushReplacement(
        MaterialWithModalsPageRoute(
          builder: (context) => widget,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<CitiesRepository>(
      builder: (context, repository, _) {
        final provider = repository.response?.content;

        if (repository.isLoading || repository.loadingFailed || provider == null || skipable) {
          if (widget.onFirstLaunch) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

            return CupertinoPageScaffold(
              backgroundColor: primaryColor,
              resizeToAvoidBottomInset: false,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    SVGImage(
                      image: ImageAsset.refashionedLogo,
                      height: 50,
                      color: white,
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            child: Text(
                              repository.loadingFailed
                                  ? repository.response?.errors != null
                                      ? "Ошибка: ${repository.response?.errors}"
                                      : "🤬"
                                  : "Маркетплейс брендовой одежды и обуви",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: repository.loadingFailed && repository.response?.errors == null
                                  ? TextStyle(fontSize: 32)
                                  : Theme.of(context).textTheme.headline1.copyWith(
                                        color: white,
                                        fontWeight: FontWeight.w300,
                                        height: 1.5,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

          return CupertinoPageScaffold(
            child: SafeArea(
              child: Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                ),
              ),
            ),
          );
        }

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

        return CupertinoPageScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: white,
          child: Column(
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
                                  push(OnboardingPage());
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
          ),
        );
      },
    );
  }
}
