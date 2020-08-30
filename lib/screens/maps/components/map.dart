import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum MarkerType { POINT_SMALL, POINT_MEDIUM, POINT_LARGE }

enum CenterMarkerAnimationStatus { STARTED, COMPLETED }

class MapPage extends StatefulWidget {
  _MapPageState _mapPageState;
  final Function(PickPoint) onMarkerClick;
  final Function(CenterMarkerAnimationStatus, {Future<Point> point}) notifyCenterPoint;

  MapPage({Key key, this.onMarkerClick, this.notifyCenterPoint}) : super(key: key);

  void showUserLocation() {
    _mapPageState._showUserLocation();
  }

  @override
  _MapPageState createState() {
    _mapPageState = _MapPageState();
    return _mapPageState;
  }
}

class _MapPageState extends State<MapPage> {
  YandexMapController controller;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  List<Placemark> placeMarks = List();
  Placemark selectedPlaceMark;
  PickPointRepository pickPointRepository;
  MarkerType markerType = MarkerType.POINT_SMALL;
  bool _needNotifyCenterPoint = true;

  @override
  void initState() {
    pickPointRepository = new PickPointRepository();
    pickPointRepository.addListener(() {
      showPickPoints();
    });

    _requestPermission();

    super.initState();
  }

  Future<void> _requestPermission() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.location];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    setState(() {
      _permissionStatus = permissionRequestResult[PermissionGroup.location];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      showUserIcon().then((value) {
        moveToPoint().then((value) {
          pickPointRepository.getPickPoints();
        });
      });
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;
              setState(() {});
              controller.enableCameraTracking(null, (msg) {
                if (msg['zoom'] >= 12 && markerType == MarkerType.POINT_SMALL) {
                  markerType = MarkerType.POINT_MEDIUM;
                  controller.changePlacemarksIcon(selectedPlaceMark, 'assets/marker_red_medium.png');
                } else if (msg['zoom'] < 12 && markerType == MarkerType.POINT_MEDIUM) {
                  markerType = MarkerType.POINT_SMALL;
                  controller.changePlacemarksIcon(selectedPlaceMark, 'assets/marker_red_small.png');
                }

                if (_needNotifyCenterPoint) {
                  if (widget.notifyCenterPoint != null) widget.notifyCenterPoint(CenterMarkerAnimationStatus.STARTED);
                  _needNotifyCenterPoint = false;
                }

                if (msg['final']) {
                  if (widget.notifyCenterPoint != null)
                    widget.notifyCenterPoint(CenterMarkerAnimationStatus.COMPLETED, point: controller.getTargetPoint());
                  _needNotifyCenterPoint = true;
                }
              });
            },
          )),
        ]);
  }

  void _showUserLocation() async {
    if (_permissionStatus == PermissionStatus.granted) {
      _needNotifyCenterPoint = false;
      await controller.moveToUser();
    }
  }

  Future<void> moveToPoint() async {
    if (_permissionStatus == PermissionStatus.granted) {
      _needNotifyCenterPoint = false;
      await controller
          .move(
              zoom: 10,
              point: Point(latitude: 55.7522200, longitude: 37.6155600),
              animation: const MapAnimation(smooth: true, duration: 2.0));
    }
  }

  void showPickPoints() {
    if (pickPointRepository.isLoaded) {
      pickPointRepository.response.content.where((element) => element.address.contains("Москва")).forEach((element) {
        var _point = Point(latitude: double.parse(element.lat), longitude: double.parse(element.lon));
        final Placemark _placemark = Placemark(
          point: _point,
          opacity: 0.8,
          iconName: 'assets/marker_red_small.png',
          onTap: (Placemark placemark, double latitude, double longitude) => {
            if (selectedPlaceMark != null)
              {
                controller.changePlacemarkIcon(
                    selectedPlaceMark,
                    markerType == MarkerType.POINT_MEDIUM
                        ? 'assets/marker_red_medium.png'
                        : 'assets/marker_red_small.png')
              },
            selectedPlaceMark = placemark,
            controller.changePlacemarkIcon(placemark, 'assets/marker_red_selected.png'),
            widget.onMarkerClick(pickPointRepository.response.content.firstWhere((element) =>
                double.parse(element.lat) == selectedPlaceMark.point.latitude &&
                double.parse(element.lon) == selectedPlaceMark.point.longitude))
          },
        );
        placeMarks.add(_placemark);
        controller.addPlacemark(_placemark);
      });
    }
  }

  Future<void> showUserIcon() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.showUserLayer(
          iconName: 'assets/marker_user_location.png',
          arrowName: 'assets/marker_user_location.png',
          accuracyCircleFillColor: Colors.green.withOpacity(0.5));
    }
  }
}
