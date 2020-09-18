import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/sell_property.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/repositories/size.dart';
import 'package:refashioned_app/screens/block/main_block.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/marketplace/components/sell_property_values_list.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

import '../../components/items_divider.dart';


class SizesPage extends StatefulWidget {
  final Function() onPush;
  final Function() onBack;
  final SizesContent sizesContent;

  const SizesPage({Key key, this.onPush, this.onBack, this.sizesContent}) : super(key: key);


  @override
  _SizesPageState createState() => _SizesPageState();
}

class _SizesPageState extends State<SizesPage> {



  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    var bloc = Provider.of<MainBloc>(context, listen: false);
    if(bloc.sizes != null ){
      return CupertinoPageScaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        child:  Stack(
            children: [
              Column(
                children: [
                  RefashionedTopBar(
                    scrollActionsProvider: ScaffoldScrollActionsProvider(),
                    data: TopBarData.simple(
                      onBack: Navigator.of(context).pop,
                      middleText: "Добавить вещь",
                      onClose: widget.onBack,
                      bottomText: " Выберите размер",
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      separatorBuilder: (BuildContext context, int index) => ItemsDivider(),
                      itemCount: bloc.sizes.length,
                      itemBuilder: (context, index){
                        return sizeItem(context, bloc.sizes[index]['code'], bloc.sizes[index]['values'], () => widget.onPush());
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
                    action: bloc.selectedSize != null ? widget.onPush : _showAlert,
                  )
              ),
            ],
          ),
      );
    }else{
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {});
      });
      return CupertinoPageScaffold(
        child: Material(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text('Загрузка'),
            ),
          ),
        ),
      );
    }
  }
  void _showAlert(){
    showModalBottomSheet(context: context, builder: (context){
      return Material(
        child: Container(
          height: 100,
          child: Center(
            child: Text('Необходимо выбрать размерную таблицу', style: Theme.of(context).textTheme.bodyText1,),
          ),
        ),
      );
    });
  }


  Widget sizeItem(context, String code, List value, Function() onPush){
    return Material(
      color: Colors.white,
      child:Tapable(
          padding:  EdgeInsets.only(left: 20, top: 25, bottom: 25),
          onTap: (){
            Provider.of<MainBloc>(context, listen: false).selectedSize = value;
            onPush();
          },
          child: Text('$code',  style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.w500),),
        ),
    );
  }
}


