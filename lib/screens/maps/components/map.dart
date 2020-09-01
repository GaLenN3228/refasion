import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/maps/map_data_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum MarkerType { SMALL, MEDIUM, POINT_SELECTED }

enum MapTouchStatus { STARTED, COMPLETED }

class MapPage extends StatefulWidget {
  static const String MARKER_ICON_SMALL = 'assets/marker_red_small.png';
  static const String MARKER_ICON_SELECTED = 'assets/marker_red_selected.png';
  static const String MARKER_ICON_MEDIUM = 'assets/marker_red_medium.png';
  static const String MARKER_ICON_USER_LOCATION = 'assets/marker_user_location.png';

  _MapPageState _mapPageState;

  final MapDataController mapDataController;
  final Function(PickPoint) onMarkerClick;
  final Function(MapTouchStatus, {Future<Point> point}) onMapTouch;

  MapPage({Key key, this.onMarkerClick, this.onMapTouch, @required this.mapDataController}) : super(key: key);

  void showUserLocation() {
    _mapPageState._showUserLocation();
  }

  void addMarkers(List<PickPoint> pickPoints) {
    _mapPageState._addMarkers(pickPoints);
  }

  Future<void> addMarker(PickPoint pickPoint) async {
    await _mapPageState._addMarker(pickPoint);
  }

  Future<void> moveToPoint(double zoom, Point point) async {
    await _mapPageState._moveToPoint(zoom, point);
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

  Placemark selectedPlaceMark;
  MarkerType markersType = MarkerType.SMALL;
  bool _allowMapTouchListener = true;

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      _showUserIcon().then((value) {
        _moveToPoint(10, Point(latitude: 55.7522200, longitude: 37.6155600));
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
                _changePlaceMarksIconsWithZoom(msg['zoom']);
                _callOnMapTouchListener(msg['final']);
              });
            },
          )),
        ]);
  }

  Future<void> _requestPermission() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.location];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    setState(() {
      _permissionStatus = permissionRequestResult[PermissionGroup.location];
    });
  }

  void _changePlaceMarksIconsWithZoom(double zoom) {
    if (zoom >= 12 && markersType == MarkerType.SMALL) {
      markersType = MarkerType.MEDIUM;
      controller.changePlacemarksIcon(selectedPlaceMark, MapPage.MARKER_ICON_MEDIUM);
    } else if (zoom < 12 && markersType == MarkerType.MEDIUM) {
      markersType = MarkerType.SMALL;
      controller.changePlacemarksIcon(selectedPlaceMark, MapPage.MARKER_ICON_SMALL);
    }
  }

  void _callOnMapTouchListener(bool isFinal) {
    if (_allowMapTouchListener) {
      if (widget.onMapTouch != null) widget.onMapTouch(MapTouchStatus.STARTED);
      _allowMapTouchListener = false;
    }
    if (isFinal) {
      if (widget.onMapTouch != null) widget.onMapTouch(MapTouchStatus.COMPLETED, point: controller.getTargetPoint());
      _allowMapTouchListener = true;
    }
  }

  void _showUserLocation() async {
    if (_permissionStatus == PermissionStatus.granted) {
      _allowMapTouchListener = false;
      await controller.moveToUser();
    }
  }

  Future<void> _moveToPoint(double zoom, Point point) async {
    if (_permissionStatus == PermissionStatus.granted) {
      _allowMapTouchListener = false;
      await controller.move(
          zoom: zoom,
          point: Point(latitude: point.latitude, longitude: point.longitude),
          animation: const MapAnimation(smooth: true, duration: 2.0));
    }
  }

  Future<void> _addMarker(PickPoint pickPoint) async {
    final Placemark _placeMark = Placemark(
      point: Point(latitude: double.parse(pickPoint.lat), longitude: double.parse(pickPoint.lon)),
      opacity: 0.8,
      iconName: MapPage.MARKER_ICON_SELECTED,
      onTap: (Placemark placeMark, double latitude, double longitude) {
        selectedPlaceMark = placeMark;
        _changeSelectedPlaceMarkIcon();
        _moveToPoint(15, Point(latitude: double.parse(pickPoint.lat) - 0.003, longitude: double.parse(pickPoint.lon)));
        widget.onMarkerClick(pickPoint);
      },
    );
    selectedPlaceMark = _placeMark;
  }

  void _addMarkers(List<PickPoint> pickPoints) {
    pickPoints.forEach((element) {
      var _point = Point(latitude: double.parse(element.lat), longitude: double.parse(element.lon));
      final Placemark _placeMark = Placemark(
        point: _point,
        opacity: 0.8,
        iconName: MapPage.MARKER_ICON_SMALL,
        onTap: (Placemark placeMark, double latitude, double longitude) {
          selectedPlaceMark = placeMark;
          _changeSelectedPlaceMarkIcon();
          var pickPoint = pickPoints.firstWhere((element) =>
              double.parse(element.lat) == selectedPlaceMark.point.latitude &&
              double.parse(element.lon) == selectedPlaceMark.point.longitude);
          _moveToPoint(
              15, Point(latitude: double.parse(pickPoint.lat) - 0.003, longitude: double.parse(pickPoint.lon)));
          widget.onMarkerClick(pickPoint);
        },
      );
      controller.addPlacemark(_placeMark);
    });
  }

  void _changeSelectedPlaceMarkIcon() {
    if (selectedPlaceMark != null) controller.changePlacemarkIcon(selectedPlaceMark, MapPage.MARKER_ICON_SELECTED);
  }

  void _resetSelectedPlaceMarkIcon() {
    if (selectedPlaceMark != null)
      controller.changePlacemarkIcon(
          selectedPlaceMark, markersType == MarkerType.MEDIUM ? MapPage.MARKER_ICON_MEDIUM : MapPage.MARKER_ICON_SMALL);
  }

  Future<void> _showUserIcon() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.showUserLayer(
          iconName: MapPage.MARKER_ICON_USER_LOCATION,
          arrowName: MapPage.MARKER_ICON_USER_LOCATION,
          accuracyCircleFillColor: Colors.green.withOpacity(0.5));
    }
  }
}
