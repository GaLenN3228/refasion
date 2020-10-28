import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/city_selector/city_tile.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class CitySelector extends StatefulWidget {
  final bool onFirstLaunch;
  final Function() onPush;

  const CitySelector({Key key, this.onFirstLaunch: false, this.onPush}) : super(key: key);

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CitiesRepository>(
      builder: (context, repository, _) {
        final provider = repository.response?.content;

        if (repository.isLoading || repository.loadingFailed || provider == null) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

          return CupertinoPageScaffold(
            child: SafeArea(
              child: Center(
                child: CupertinoActivityIndicator(),
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
                                  widget.onPush?.call();
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
