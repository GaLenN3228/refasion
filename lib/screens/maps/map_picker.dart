import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:refashioned_app/screens/maps/components/map.dart';
import 'package:refashioned_app/screens/maps/components/sheet_data/pickup_point_address.dart';
import 'package:refashioned_app/utils/colors.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapsPickerPage extends StatefulWidget {
  final Function() onPush;

  MapsPickerPage({Key key, this.onPush}) : super(key: key);

  @override
  _MapsPickerPageState createState() => _MapsPickerPageState();
}

class _MapsPickerPageState extends State<MapsPickerPage> with TickerProviderStateMixin {
  AnimationController _centerMarkerController;
  Animation<Offset> _centerMarkerAnimation;
  Animation<double> _centerMarkerShadowAnimation;
  bool _centerMarkerRouteFlag = true;

  SolidBottomSheet _solidBottomSheet;
  SolidController _bottomSheetController;

  PickPoint _pickPoint;

  MapPage _mapPage;

  void _centerMarkerAnimationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      startCenterMarkerAnimation();
    }
  }

  @override
  void initState() {
    _mapPage = MapPage(
      onMarkerClick: (point) {
        _pickPoint = point;
        if (_pickPoint != null) {
          _bottomSheetController.show();
        }
      },
      notifyCenterPoint: (centerMarkerAnimationStatus, {Future<Point> point}) {
        animateCenterMarker(centerMarkerAnimationStatus);
      },
    );
    _bottomSheetController = SolidController();
    _solidBottomSheet = _createSolidBottomSheet();
    super.initState();
  }

  void startCenterMarkerAnimation() {
    _bottomSheetController.hide();
    setState(() {
      if (_centerMarkerController != null) {
        _centerMarkerController.reset();
      }

      _centerMarkerController = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );
      _centerMarkerController.addStatusListener(_centerMarkerAnimationListener);
      _centerMarkerAnimation = Tween<Offset>(
              begin: Offset(0.0, (_centerMarkerRouteFlag) ? 0.0 : -0.03),
              end: Offset(0.0, (_centerMarkerRouteFlag) ? -0.03 : 0.0))
          .animate(_centerMarkerController);
      _centerMarkerShadowAnimation =
          Tween<double>(begin: (_centerMarkerRouteFlag) ? 1 : 0.3, end: (_centerMarkerRouteFlag) ? 0.3 : 1)
              .animate(_centerMarkerController);
      _centerMarkerController.forward();
      _centerMarkerRouteFlag = !_centerMarkerRouteFlag;
    });
  }

  void finishCenterMarkerAnimation() {
    _bottomSheetController.show();
    setState(() {
      if (_centerMarkerAnimation != null && _centerMarkerShadowAnimation != null) {
        var centerMarkerCurrentValue = _centerMarkerAnimation.value.dy;
        var centerMarkerShadowCurrentValue = _centerMarkerShadowAnimation.value;

        if (_centerMarkerController != null) {
          _centerMarkerController.reset();
        }

        _centerMarkerController = AnimationController(duration: Duration(milliseconds: 100), vsync: this);
        _centerMarkerAnimation = Tween<Offset>(begin: Offset(0.0, centerMarkerCurrentValue), end: Offset(0.0, 0.0))
            .animate(_centerMarkerController);
        _centerMarkerShadowAnimation =
            Tween<double>(begin: centerMarkerShadowCurrentValue, end: 1).animate(_centerMarkerController);
        _centerMarkerController.forward();
        _centerMarkerRouteFlag = true;
      }
    });
  }

  SolidBottomSheet _createSolidBottomSheet() {
    return SolidBottomSheet(
        maxHeight: 160,
        canUserSwipe: false,
        draggableBody: false,
        controller: _bottomSheetController,
        headerBar: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {_mapPage.showUserLocation()},
                  child: Container(
                      margin: EdgeInsets.all(16),
                      width: 170,
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/svg/search.svg",
                            width: 24,
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              "Искать по адресу",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "SF UI Text",
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                  height: 1.2),
                            ),
                          )
                        ],
                      )))),
          Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {_mapPage.showUserLocation()},
                  child: Container(
                      margin: EdgeInsets.all(16),
                      width: 50,
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/show_location.svg",
                          width: 22,
                          height: 22,
                        ),
                      )))),
        ]),
        body: PickupPointAddress(point: _pickPoint) // Your body here
        );
  }

  @override
  void dispose() {
    _centerMarkerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _solidBottomSheet,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              child: ChangeNotifierProvider<PickPointRepository>(
            create: (_) => PickPointRepository(),
            child: _mapPage,
          )),
          Center(
              child: Stack(children: [
            (_centerMarkerAnimation != null)
                ? SlideTransition(
                    position: _centerMarkerAnimation,
                    child: Center(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 60),
                          child: Image.asset(
                            'assets/point_center.png',
                            height: 72,
                          )),
                    ),
                  )
                : Center(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: Image.asset(
                          'assets/point_center.png',
                          height: 72,
                        )),
                  ),
            Center(
                child: (_centerMarkerShadowAnimation != null)
                    ? FadeTransition(
                        opacity: _centerMarkerShadowAnimation,
                        child: Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Image.asset(
                            'assets/marker_center_shadow.png',
                            height: 14,
                          ),
                        ))
                    : Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Image.asset(
                          'assets/marker_center_shadow.png',
                          height: 14,
                        ),
                      ))
          ])),
        ],
      ),
    );
  }

  void animateCenterMarker(CenterMarkerAnimationStatus centerMarkerAnimationStatus) {
    switch (centerMarkerAnimationStatus) {
      case CenterMarkerAnimationStatus.STARTED:
        startCenterMarkerAnimation();
        break;

      case CenterMarkerAnimationStatus.COMPLETED:
        finishCenterMarkerAnimation();
        break;
    }
  }

  void showBottomSheet(BuildContext context, PickPoint point) {
//    showCupertinoModalBottomSheet(
//        barrierColor: Colors.black.withAlpha(1),
//        expand: false,
//        elevation: 4,
//        isDismissible: true,
//        context: context,
//        builder: (context, controller) => PickupPointAddress(point: point));
  }
}
