import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/utils/colors.dart';

class SizesPage extends StatefulWidget {
  final Function(Sizes) onPush;
  final Function() onBack;
  final Function() onClose;
  final Function(String url, String title) openInfoWebViewBottomSheet;

  const SizesPage(
      {Key key, this.onPush, this.onBack, this.onClose, this.openInfoWebViewBottomSheet})
      : super(key: key);

  @override
  _SizesPageState createState() => _SizesPageState();
}

class _SizesPageState extends State<SizesPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RefashionedTopBar(
                scrollActionsProvider: ScaffoldScrollActionsProvider(),
                data: TopBarData.simple(
                  onBack: Navigator.of(context).pop,
                  middleText: "Добавить вещь",
                  onClose: widget.onClose,
                  bottomText: "Выберите размерную сетку",
                ),
              ),
              Expanded(child: Consumer<SizeRepository>(builder: (context, sizeRepository, _) {
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
                return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    separatorBuilder: (BuildContext context, int index) => ItemsDivider(),
                    itemCount: sizes.length + 1,
                    itemBuilder: (BuildContext context, int index) => index == sizes.length
                        ? Padding(
                            padding: const EdgeInsets.only(top: 34, left: 16),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => widget.openInfoWebViewBottomSheet(
                                  "https://refashioned.ru/size", "ТАБЛИЦА РАЗМЕРОВ"),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SVGIcon(
                                    icon: IconAsset.info,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Как определить размер вещи?",
                                    style: Theme.of(context).textTheme.headline5.copyWith(
                                        decoration: TextDecoration.underline, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : sizeItem(context, sizes[index], (sizes) => widget.onPush(sizes)));
              }))
            ],
          ),
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

  Widget sizeItem(context, Sizes size, Function(Sizes) onPush) {
    return Material(
      color: Colors.white,
      child: Tapable(
        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
        onTap: () {
          onPush(size);
        },
        child: Text(
          '${size.code}',
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
