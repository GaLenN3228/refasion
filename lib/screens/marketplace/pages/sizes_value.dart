import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class SizeValuesPage extends StatefulWidget {
  final Function(Values) onPush;
  final Function() onBack;
  final Sizes sizes;

  const SizeValuesPage({Key key, this.onPush, this.onBack, this.sizes}) : super(key: key);

  @override
  _SizeValuesPageState createState() => _SizeValuesPageState();
}

class _SizeValuesPageState extends State<SizeValuesPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              RefashionedTopBar(
                data: TopBarData.simple(
                  onBack: Navigator.of(context).pop,
                  middleText: "Добавить вещь",
                  onClose: widget.onBack,
                  bottomText: "Выберите размер",
                ),
              ),
              Expanded(
                  child: ListView.separated(
                padding: EdgeInsets.all(0),
                separatorBuilder: (BuildContext context, int index) => ItemsDivider(),
                itemCount: widget.sizes.values.length,
                itemBuilder: (context, index) {
                  return sizeValueItem(
                      context, widget.sizes.values[index], (value) => widget.onPush(value));
                },
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget sizeValueItem(context, Values value, Function(Values) onPush) {
    return Material(
      color: Colors.white,
      child: Tapable(
        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
        onTap: () {
          onPush(value);
        },
        child: Text(
          '${value.value}',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
