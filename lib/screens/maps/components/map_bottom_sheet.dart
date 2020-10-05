import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';

typedef void OnBottomSheetSizeChange(Size size);

class MapBottomSheet extends StatefulWidget {
  final GlobalKey bottomSheetKey;
  final OnBottomSheetSizeChange onBottomSheetSizeChange;
  final Function() onFinishButtonClick;
  final Function() onCloseButtonClick;

  const MapBottomSheet(
      {Key key, this.bottomSheetKey, this.onBottomSheetSizeChange, this.onFinishButtonClick, this.onCloseButtonClick})
      : super(key: key);

  @override
  _MapBottomSheetState createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MapBottomSheetDataController, MapBottomSheetData>(
        builder: (context, mapBottomSheetDataController, mapBottomSheetData, child) {
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
        padding: EdgeInsets.only(bottom: 32),
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
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                mapBottomSheetDataController.currentBottomSheetData.title != null
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          mapBottomSheetDataController.currentBottomSheetData.title,
                          style: textTheme.headline1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(),
                mapBottomSheetDataController.currentBottomSheetData.isCancelPointEnable
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => {widget.onCloseButtonClick()},
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 20),
                            width: 22,
                            height: 22,
                            decoration: new BoxDecoration(
                              color: Color(0xFFBFBFBF),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                                padding: EdgeInsets.all(4),
                                child: SVGIcon(
                                  icon: IconAsset.close,
                                  color: Colors.white,
                                ))))
                    : SizedBox()
              ]),
            ),
            mapBottomSheetDataController.currentBottomSheetData.type != null
                ? Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Text(
                      mapBottomSheetDataController.currentBottomSheetData.type.toUpperCase(),
                      style: textTheme.subtitle1,
                    ),
                  )
                : SizedBox(),
            mapBottomSheetDataController.currentBottomSheetData.address != null
                ? Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(children: [
                      mapBottomSheetDataController.currentBottomSheetData.addressTitle != null
                          ? Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: Text(
                                mapBottomSheetDataController.currentBottomSheetData.addressTitle,
                                style: textTheme.bodyText2,
                                maxLines: 1,
                              ))
                          : SizedBox(),
                      Expanded(
                          child: Container(
                              child: Text(
                        mapBottomSheetDataController.currentBottomSheetData.address,
                        style: textTheme.subtitle1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ))),
                    ]))
                : SizedBox(),
            mapBottomSheetDataController.currentBottomSheetData.workSchedule != null
                ? Container(
                    margin: const EdgeInsets.only(top: 4, left: 20, right: 16),
                    child: Row(children: [
                      mapBottomSheetDataController.currentBottomSheetData.workScheduleTitle != null
                          ? Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: Text(
                                mapBottomSheetDataController.currentBottomSheetData.workScheduleTitle,
                                style: textTheme.bodyText2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                          : SizedBox(),
                      Expanded(
                        child: Container(
                            child: Text(
                          mapBottomSheetDataController.currentBottomSheetData.workSchedule,
                          style: textTheme.subtitle1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                      )
                    ]))
                : SizedBox(),
            mapBottomSheetDataController.currentBottomSheetData.info != null
                ? Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 20, right: 2),
                    child: Text(
                      mapBottomSheetDataController.currentBottomSheetData.info,
                      style: textTheme.subtitle1,
                    ),
                  )
                : SizedBox(),
            mapBottomSheetDataController.currentBottomSheetData.hint != null
                ? Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                    child: Text(
                      mapBottomSheetDataController.currentBottomSheetData?.hint,
                      style: textTheme.bodyText2,
                    ),
                  )
                : SizedBox(),
            mapBottomSheetDataController.currentBottomSheetData.finishButtonText != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, top: 22, right: 22),
                    child: Button(
                      mapBottomSheetDataController.currentBottomSheetData.finishButtonText,
                      buttonStyle: mapBottomSheetDataController.currentBottomSheetData.isFinishButtonEnable
                          ? CustomButtonStyle.dark
                          : CustomButtonStyle.dark_gray,
                      height: 45,
                      width: double.infinity,
                      borderRadius: 5,
                      onClick: mapBottomSheetDataController.currentBottomSheetData.isFinishButtonEnable
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
    });
  }
}
