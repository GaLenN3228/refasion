import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/maps/map_bottom_sheet_data_controller.dart';

typedef void OnBottomSheetSizeChange(Size size);

class MapBottomSheet extends StatefulWidget {
  final GlobalKey bottomSheetKey;
  final OnBottomSheetSizeChange onBottomSheetSizeChange;
  final Function() onFinishButtonClick;

  const MapBottomSheet({Key key, this.bottomSheetKey, this.onBottomSheetSizeChange, this.onFinishButtonClick})
      : super(key: key);

  @override
  MapBottomSheetState createState() => MapBottomSheetState();
}

class MapBottomSheetState extends State<MapBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mapBottomSheetDataController = context.watch<MapBottomSheetDataController>();
    //bottom sheet size change callback
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final keyContext = widget.bottomSheetKey.currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        if (widget.onBottomSheetSizeChange != null) widget.onBottomSheetSizeChange(box.size);
      }
    });

    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
        child: Container(
      key: widget.bottomSheetKey,
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 13,
              ),
              Container(
                width: 30,
                height: 3,
                decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
              ),
            ],
          ),
          mapBottomSheetDataController.title != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 10.0, left: 20),
                  child: Text(
                    mapBottomSheetDataController.title,
                    style: textTheme.headline1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox(),
          mapBottomSheetDataController.type != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    mapBottomSheetDataController.type.toUpperCase(),
                    style: textTheme.subtitle1,
                  ),
                )
              : SizedBox(),
          mapBottomSheetDataController.address != null
              ? Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(children: [
                    mapBottomSheetDataController.addressTitle != null
                        ? Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: Text(
                              mapBottomSheetDataController.addressTitle,
                              style: textTheme.bodyText2,
                              maxLines: 1,
                            ))
                        : SizedBox(),
                    Expanded(
                        child: Container(
                            child: Text(
                      mapBottomSheetDataController.address,
                      style: textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ))),
                  ]))
              : SizedBox(),
          mapBottomSheetDataController.workSchedule != null
              ? Container(
                  margin: const EdgeInsets.only(top: 4, left: 20, right: 16),
                  child: Row(children: [
                    mapBottomSheetDataController.workScheduleTitle != null
                        ? Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: Text(
                              mapBottomSheetDataController.workScheduleTitle,
                              style: textTheme.bodyText2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))
                        : SizedBox(),
                    Expanded(
                      child: Container(
                          child: Text(
                        mapBottomSheetDataController.workSchedule,
                        style: textTheme.subtitle1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    )
                  ]))
              : SizedBox(),
          mapBottomSheetDataController.info != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, left: 20, right: 2),
                  child: Text(
                    mapBottomSheetDataController.info,
                    style: textTheme.subtitle1,
                  ),
                )
              : SizedBox(),
          mapBottomSheetDataController.hint != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Text(
                    mapBottomSheetDataController?.hint,
                    style: textTheme.bodyText2,
                  ),
                )
              : SizedBox(),
          mapBottomSheetDataController.onFinishButtonClick != null &&
                  mapBottomSheetDataController.finishButtonText != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, top: 22, right: 22),
                  child: Button(
                    mapBottomSheetDataController.finishButtonText,
                    buttonStyle:
                        mapBottomSheetDataController.isFinishButtonEnable ? ButtonStyle.dark : ButtonStyle.dark_gray,
                    height: 45,
                    width: double.infinity,
                    borderRadius: 5,
                    onClick: mapBottomSheetDataController.isFinishButtonEnable
                        ? () {
                            widget.onFinishButtonClick();
                          }
                        : () {},
                  ),
                )
              : SizedBox()
        ],
      ),
    ));
  }
}
