import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/repositories/sell_properties.dart';

class SellPropertiesPage extends StatefulWidget {
  final Function(List<SellProperty>) onPush;
  final Function() onSkip;
  final List<Category> categories;

  const SellPropertiesPage({Key key, this.onPush, this.categories, this.onSkip})
      : super(key: key);

  @override
  _SellPropertiesPageState createState() => _SellPropertiesPageState();
}

class _SellPropertiesPageState extends State<SellPropertiesPage> {
  SellPropertiesRepository sellPropertiesRepository;

  @override
  void initState() {
    sellPropertiesRepository = SellPropertiesRepository();

    sellPropertiesRepository.addListener(() {
      if (sellPropertiesRepository.loadingFailed ||
          sellPropertiesRepository.response.status.code != 200) widget.onSkip();

      if (sellPropertiesRepository.isLoaded)
        widget.onPush(sellPropertiesRepository.response.content);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Загрузка cвойств",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
