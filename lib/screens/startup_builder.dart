import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/city_selector/city_selector_page.dart';
import 'package:refashioned_app/screens/components/empty_page.dart';
import 'package:refashioned_app/screens/tab_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class StartUpBuilder extends StatefulWidget {
  @override
  _StartUpBuilderState createState() => _StartUpBuilderState();
}

class _StartUpBuilderState extends State<StartUpBuilder> {
  bool canSkip = false;

  @override
  Widget build(BuildContext context) {
    final citiesRepository = context.watch<CitiesRepository>();

    if (citiesRepository.isLoading) return EmptyPage(text: "Загрузка городов");

    if (citiesRepository.loadingFailed && !canSkip)
      return EmptyPage(
        text: "Ошибка загрузки городов",
        onPush: () => setState(() => canSkip = true),
      );

    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return EmptyPage(text: "Загрузка данных");

          if (!snapshot.hasData)
            return EmptyPage(text: "Не удалось загрузить данные");

          if (snapshot.hasError)
            return EmptyPage(text: "Ошибка: " + snapshot.error.toString());

          final prefs = snapshot.data;

          if (prefs.containsKey("city_id")) {
            final cityId = prefs.getString("city_id");

            final check =
                citiesRepository.response.content.checkSavedCity(cityId);

            if (check) return TabSwitcher();
          }

          return CitySelectorPage(citiesRepository: citiesRepository);
        });
  }
}
