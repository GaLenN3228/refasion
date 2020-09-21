import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class SizesPage extends StatefulWidget {
  final Function() onPush;
  final Function() onBack;
  final Category topCategory;

  const SizesPage({Key key, this.onPush, this.onBack, this.topCategory}) : super(key: key);

  @override
  _SizesPageState createState() => _SizesPageState();
}

class _SizesPageState extends State<SizesPage> {
  SizeRepository sizeRepository;


  @override
  void initState() {
    sizeRepository = SizeRepository();
    sizeRepository.getSizes(widget.topCategory.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeRepository = context.watch<SizeRepository>();
    sizeRepository.getSizes(widget.topCategory.id);
    if (sizeRepository.isLoading && sizeRepository.response == null)
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: accentColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );

    if (sizeRepository.loadingFailed)
      return Center(
        child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
      );

    var sizes = sizeRepository.response.content.sizes;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              RefashionedTopBar(
                scrollActionsProvider: ScaffoldScrollActionsProvider(),
                data: TopBarData.simple(
                  onBack: Navigator.of(context).pop,
                  middleText: "Добавить вещь",
                  onClose: widget.onBack,
                  bottomText: "Выберите размер",
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  separatorBuilder: (BuildContext context, int index) => ItemsDivider(),
                  itemCount: sizes.length,
                  itemBuilder: (context, index) {
                    return sizeItem(
                        context, sizes[index].code, sizes[index].values, () => widget.onPush());
                  },
                ),
              ),
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomButton(
                title: "ПРОДОЛЖИТЬ",
                action: widget.onPush,
              )),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            child: Container(
              height: 100,
              child: Center(
                child: Text(
                  'Необходимо выбрать размерную таблицу',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          );
        });
  }

  Widget sizeItem(context, String code, List value, Function() onPush) {
    return Material(
      color: Colors.white,
      child: Tapable(
        padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
        onTap: () {
          onPush();
        },
        child: Text(
          '$code',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
