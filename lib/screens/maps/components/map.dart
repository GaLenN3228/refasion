import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/maps/controllers/map_data_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum MarkerType { SMALL, MEDIUM, POINT_SELECTED }

enum MapCameraListenerStatus { STARTED, COMPLETED }

class MapPage extends StatefulWidget {
  static const String MARKER_ICON_SMALL = 'assets/icons/png/marker_red_small.png';
  static const String MARKER_ICON_SELECTED = 'assets/icons/png/marker_red_selected.png';
  static const String MARKER_ICON_MEDIUM = 'assets/icons/png/marker_red_medium.png';
  static const String MARKER_ICON_USER_LOCATION = 'assets/icons/png/marker_user_location.png';

  static const double ZOOM_TO_POINT_VALUE = 17;
  static const double ZOOM_TO_BOUNDS_VALUE = 10;
  static const double ZOOM_SELECTED_MARKER_DIFF = 0.0005;

  _MapPageState _mapPageState;

  final MapDataController mapDataController;
  final Function(PickPoint) onMarkerClick;
  final Function(MapCameraListenerStatus, {Future<Point> point}) onMapCameraListener;
  final Function() mapCameraFirstInit;

  MapPage(
      {Key key,
      this.onMarkerClick,
      @required this.onMapCameraListener,
      @required this.mapDataController,
      @required this.mapCameraFirstInit})
      : super(key: key);

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

  void resetSelectedPlaceMark() {
    _mapPageState._resetSelectedPlaceMark();
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
  bool _allowStartMapCameraListener = true;
  bool _allowFinishMapCameraListener = true;

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;
              _mapCameraFirstInit();
              controller.enableCameraTracking(null, (msg) {
                _changePlaceMarksIconsWithZoom(msg['zoom']);
                _callOnMapCameraListener(msg['final']);
              });
            },
          )),
        ]);
  }

  Future<void> _requestPermission() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.location];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    _permissionStatus = permissionRequestResult[PermissionGroup.location];
    _mapCameraFirstInit();
  }

  void _mapCameraFirstInit() {
    if (controller != null) {
      _showUserIcon().then((value) {
        widget.mapCameraFirstInit();
      });
    }
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

  void _callOnMapCameraListener(bool isFinal) {
    if (_allowStartMapCameraListener) {
      if (widget.onMapCameraListener != null) widget.onMapCameraListener(MapCameraListenerStatus.STARTED);
      _allowStartMapCameraListener = false;
    }
    if (isFinal) {
      if (widget.onMapCameraListener != null && _allowFinishMapCameraListener)
        widget.onMapCameraListener(MapCameraListenerStatus.COMPLETED, point: controller.getTargetPoint());
      _allowStartMapCameraListener = true;
      _allowFinishMapCameraListener = true;
    }
  }

  void _showUserLocation() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.moveToUser();
    }
  }

  Future<void> _moveToPoint(double zoom, Point point) async {
    if (_permissionStatus == PermissionStatus.granted) {
      _allowFinishMapCameraListener = false;
      _allowStartMapCameraListener = false;
      await controller.move(
          zoom: zoom,
          point: Point(latitude: point.latitude, longitude: point.longitude),
          animation: const MapAnimation(smooth: true, duration: 2.0));
    }
  }

  Future<void> _addMarker(PickPoint pickPoint) async {
    final Placemark _placeMark = Placemark(
      point: Point(latitude: pickPoint.latitude, longitude: pickPoint.longitude),
      opacity: 0.8,
      iconName: MapPage.MARKER_ICON_SELECTED,
      onTap: (Placemark placeMark, double latitude, double longitude) {
        selectedPlaceMark = placeMark;
        _changeSelectedPlaceMarkIcon();
        _moveToPoint(
            MapPage.ZOOM_TO_POINT_VALUE, Point(latitude: pickPoint.latitude - MapPage.ZOOM_SELECTED_MARKER_DIFF, longitude: pickPoint.longitude));
        widget.onMarkerClick(pickPoint);
      },
    );
    controller.addPlacemark(_placeMark);
    selectedPlaceMark = _placeMark;
  }

  void _addMarkers(List<PickPoint> pickPoints) {
    pickPoints.forEach((element) {
      var _point = Point(latitude: element.latitude, longitude: element.longitude);
      final Placemark _placeMark = Placemark(
        point: _point,
        opacity: 0.8,
        iconName: MapPage.MARKER_ICON_SMALL,
        onTap: (Placemark placeMark, double latitude, double longitude) {
          _resetSelectedPlaceMarkIcon();
          selectedPlaceMark = placeMark;
          _changeSelectedPlaceMarkIcon();
          var pickPoint = pickPoints.firstWhere((element) =>
              element.latitude == selectedPlaceMark.point.latitude &&
              element.longitude == selectedPlaceMark.point.longitude);
          _moveToPoint(
              MapPage.ZOOM_TO_POINT_VALUE, Point(latitude: pickPoint.latitude - MapPage.ZOOM_SELECTED_MARKER_DIFF, longitude: pickPoint.longitude));
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

  void _resetSelectedPlaceMark() {
    _resetSelectedPlaceMarkIcon();
    selectedPlaceMark = null;
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
