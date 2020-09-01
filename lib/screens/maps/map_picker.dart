import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:refashioned_app/screens/maps/components/buttons/geolocation_button.dart';
import 'package:refashioned_app/screens/maps/components/buttons/search_button.dart';
import 'package:refashioned_app/screens/maps/components/map.dart';
import 'package:refashioned_app/screens/maps/components/map_bottom_sheet.dart';
import 'package:refashioned_app/screens/maps/controllers/map_bottom_sheet_data_controller.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'controllers/map_data_controller.dart';

enum PickUpPointsCompany { BOXBERRY }

class MapsPickerPage extends StatefulWidget {
  final MapDataController mapDataController;
  final MapBottomSheetDataController mapBottomSheetDataController;

  MapsPickerPage({Key key, @required this.mapDataController, @required this.mapBottomSheetDataController})
      : super(key: key);

  @override
  _MapsPickerPageState createState() => _MapsPickerPageState();
}

class _MapsPickerPageState extends State<MapsPickerPage> with TickerProviderStateMixin {
  MapPage _mapPage;

  AnimationController _centerMarkerController;
  Animation<Offset> _centerMarkerAnimation;
  Animation<double> _centerMarkerShadowAnimation;
  bool _centerMarkerRouteFlag = true;

  SolidBottomSheet _bottomSheet;
  SolidController _bottomSheetController;
  double _bottomSheetHeight;
  final GlobalKey _bottomSheetKey = GlobalKey();
  OnBottomSheetSizeChange _onBottomSheetSizeChange;

  PickPointRepository pickPointRepository;
  PickPoint _selectedPickPoint;

  void _centerMarkerAnimationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      startCenterMarkerAnimation();
    }
  }

  @override
  void initState() {
    _mapPage = MapPage(
      mapDataController: widget.mapDataController,
      onMarkerClick: (pickPoint) {
        _selectedPickPoint = pickPoint;
        if (widget.mapDataController.pickUpPointsCompany != null) changeBottomSheetStateWithPickPoint();
      },
      onMapTouch: (mapTouchStatus, {Future<Point> point}) {
        switch (mapTouchStatus) {
          case MapTouchStatus.STARTED:
            if (widget.mapDataController.centerMarkerEnable) startCenterMarkerAnimation();
            hideBottomSheetWithHeight();
            break;

          case MapTouchStatus.COMPLETED:
            if (widget.mapDataController.centerMarkerEnable) {
              point.then((point) {
                _selectedPickPoint = PickPoint(latitude: point.latitude, longitude: point.longitude);
              });
              finishCenterMarkerAnimation();
              changeBottomSheetStateWithCenterMarker();
            }
            showBottomSheetWithHeight();
            break;
        }
      },
    );

    if (widget.mapDataController.pickUpPointsCompany != null) {
      pickPointRepository = new PickPointRepository();
      pickPointRepository.getPickPoints();
      pickPointRepository.addListener(() {
        _mapPage.addMarkers(
            pickPointRepository.response.content.where((element) => element.address.contains("Москва")).toList());
      });
    }

    widget.mapDataController.addListener(() {
      if (widget.mapDataController.pickPoint != null) {
        _selectedPickPoint = widget.mapDataController.pickPoint;
        widget.mapBottomSheetDataController.currentBottomSheetData.address = widget.mapDataController.pickPoint.address;
        changeBottomSheetStateWithExternalPickPoint();
        _mapPage.moveToPoint(
            15,
            Point(
                latitude: widget.mapDataController.pickPoint.latitude,
                longitude: widget.mapDataController.pickPoint.longitude));
      }
    });

    _onBottomSheetSizeChange = (size) {
      if (_bottomSheetHeight == null) {
        _bottomSheetController?.height = size.height;
        _bottomSheetHeight = size.height;
      } else {
        _bottomSheetHeight = size.height;
      }
    };
    widget.mapBottomSheetDataController.setCurrentBottomSheetData = MapBottomSheetDataType.PREVIEW;
    _bottomSheetController = SolidController();
    _bottomSheet = _createSolidBottomSheet();

    super.initState();
  }

  void changeBottomSheetStateWithCenterMarker() {
    hideBottomSheetWithHeight();
    //delay to await bottom sheet animation
    Future.delayed(Duration(milliseconds: 100), () {
      if (_selectedPickPoint != null) {
        bool addressFound = true;
        if (addressFound) {
          _selectedPickPoint.address = "Москва, ул. Ленина, д.20";
          widget.mapBottomSheetDataController.setCurrentBottomSheetData = MapBottomSheetDataType.ADDRESS;
          widget.mapBottomSheetDataController.currentBottomSheetData.address = _selectedPickPoint.address;
        } else {
          widget.mapBottomSheetDataController.setCurrentBottomSheetData = MapBottomSheetDataType.NOT_FOUND;
        }
      }
      showBottomSheetWithHeight();
    });
  }

  void changeBottomSheetStateWithPickPoint() {
    hideBottomSheetWithHeight();
    //delay to await bottom sheet animation
    Future.delayed(Duration(milliseconds: 100), () {
      if (_selectedPickPoint != null) {
        widget.mapBottomSheetDataController.setCurrentBottomSheetData = MapBottomSheetDataType.ADDRESS;
        widget.mapBottomSheetDataController.currentBottomSheetData.address = _selectedPickPoint.address;
        widget.mapBottomSheetDataController.currentBottomSheetData.type = _selectedPickPoint.type;
      }
      showBottomSheetWithHeight(duration: 150);
    });
  }

  void changeBottomSheetStateWithExternalPickPoint() {
    hideBottomSheetWithHeight();
    //delay to await bottom sheet animation
    Future.delayed(Duration(milliseconds: 100), () {
      widget.mapBottomSheetDataController.setCurrentBottomSheetData = MapBottomSheetDataType.ADDRESS;
      widget.mapBottomSheetDataController.currentBottomSheetData.address = _selectedPickPoint.address;
      showBottomSheetWithHeight();
    });
  }

  @override
  void dispose() {
    _centerMarkerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _bottomSheet,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: _mapPage,
          ),
          widget.mapDataController.centerMarkerEnable
              ? Center(
                  child: Stack(children: [
                  (_centerMarkerAnimation != null)
                      ? SlideTransition(
                          position: _centerMarkerAnimation,
                          child: Center(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 60),
                                child: Image.asset(
                                  'assets/icons/png/marker_center.png',
                                  height: 72,
                                )),
                          ),
                        )
                      : Center(
                          child: Container(
                              margin: EdgeInsets.only(bottom: 60),
                              child: Image.asset(
                                'assets/icons/png/marker_center.png',
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
                                  'assets/icons/png/marker_center_shadow.png',
                                  height: 14,
                                ),
                              ))
                          : Container(
                              margin: EdgeInsets.only(top: 6),
                              child: Image.asset(
                                'assets/icons/png/marker_center_shadow.png',
                                height: 14,
                              ),
                            ))
                ]))
              : SizedBox(),
        ],
      ),
    );
  }

  SolidBottomSheet _createSolidBottomSheet() {
    return SolidBottomSheet(
        showOnAppear: true,
        canUserSwipe: false,
        draggableBody: false,
        controller: _bottomSheetController,
        headerBar: Stack(children: [
          widget.mapDataController.onSearchButtonClick != null
              ? SearchButton(onSearchButtonClick: widget.mapDataController.onSearchButtonClick)
              : SizedBox(),
          GeolocationButton(onGeolocationButtonClick: () {
            _mapPage.showUserLocation();
          }),
        ]),
        body: ChangeNotifierProvider<MapBottomSheetDataController>(
            create: (_) => widget.mapBottomSheetDataController,
            builder: (context, _) {
              return ChangeNotifierProvider.value(
                  value: widget.mapBottomSheetDataController.currentBottomSheetData,
                  child: MapBottomSheet(
                    bottomSheetKey: _bottomSheetKey,
                    onBottomSheetSizeChange: _onBottomSheetSizeChange,
                    onFinishButtonClick: () {
                      if (_selectedPickPoint != null) {
                        widget.mapBottomSheetDataController.currentBottomSheetData
                            .onFinishButtonClick(_selectedPickPoint);
                      }
                    },
                  ));
            }));
  }

  void showBottomSheetWithHeight({int duration}) {
    Future.delayed(Duration(milliseconds: duration ?? 100), () {
      _bottomSheetController?.height = _bottomSheetHeight;
    });
  }

  void hideBottomSheetWithHeight() {
    _bottomSheetController?.height = 0;
  }

  void startCenterMarkerAnimation() {
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
}
