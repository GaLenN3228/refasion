import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:refashioned_app/screens/maps/map_data_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum MarkerType { POINT_SMALL, POINT_MEDIUM, POINT_LARGE }

enum MapTouchStatus { STARTED, COMPLETED }

class MapPage extends StatefulWidget {
  final MapDataController mapDataController;

  _MapPageState _mapPageState;
  final Function(PickPoint) onMarkerClick;
  final Function(MapTouchStatus, {Future<Point> point}) onMapTouch;

  MapPage({Key key, this.onMarkerClick, this.onMapTouch, @required this.mapDataController}) : super(key: key);

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
  bool _allowMapTouch = true;

  @override
  void initState() {
    if (widget.mapDataController.pickUpPointsCompany != null) {
      pickPointRepository = new PickPointRepository();
      pickPointRepository.addListener(() {
        showPickPoints();
      });
    }

    widget.mapDataController.addListener(() {
      moveToPoint(15, widget.mapDataController.point.latitude, widget.mapDataController.point.longitude);
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
        moveToPoint(10, 55.7522200, 37.6155600).then((value) {
          pickPointRepository?.getPickPoints();
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

                if (_allowMapTouch) {
                  if (widget.onMapTouch != null) widget.onMapTouch(MapTouchStatus.STARTED);
                  _allowMapTouch = false;
                }

                if (msg['final']) {
                  if (widget.onMapTouch != null)
                    widget.onMapTouch(MapTouchStatus.COMPLETED, point: controller.getTargetPoint());
                  _allowMapTouch = true;
                }
              });
            },
          )),
        ]);
  }

  void _showUserLocation() async {
    if (_permissionStatus == PermissionStatus.granted) {
      _allowMapTouch = false;
      await controller.moveToUser();
    }
  }

  Future<void> moveToPoint(double zoom, double latitude, double longitude) async {
    if (_permissionStatus == PermissionStatus.granted) {
      _allowMapTouch = false;
      await controller.move(
          zoom: 15,
          point: Point(latitude: latitude, longitude: longitude),
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
          onTap: (Placemark placemark, double latitude, double longitude) {
            if (selectedPlaceMark != null) {
              controller.changePlacemarkIcon(
                  selectedPlaceMark,
                  markerType == MarkerType.POINT_MEDIUM
                      ? 'assets/marker_red_medium.png'
                      : 'assets/marker_red_small.png');
            }
            selectedPlaceMark = placemark;
            controller.changePlacemarkIcon(placemark, 'assets/marker_red_selected.png');
            var point = pickPointRepository.response.content.firstWhere((element) =>
            double.parse(element.lat) == selectedPlaceMark.point.latitude &&
                double.parse(element.lon) == selectedPlaceMark.point.longitude);
            moveToPoint(15, double.parse(point.lat), double.parse(point.lon));
            widget.onMarkerClick(point);
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
