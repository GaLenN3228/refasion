import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum MarkerType { POINT_SMALL, POINT_MEDIUM, POINT_LARGE }

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LayersExample();
  }
}

class _LayersExample extends StatefulWidget {
  @override
  _LayersExampleState createState() => _LayersExampleState();
}

class _LayersExampleState extends State<_LayersExample> {
  YandexMapController controller;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  List<Placemark> placeMarks = List();
  Placemark selectedPlaceMark;
  PickPointRepository pickPointRepository;

  MarkerType markerType = MarkerType.POINT_SMALL;

  @override
  void initState() {
    pickPointRepository = new PickPointRepository();
    pickPointRepository.addListener(() {
      showPickPoints();
    });
    pickPointRepository.getPickPoints();
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.location];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    setState(() {
      _permissionStatus = permissionRequestResult[PermissionGroup.location];
      showUserLayer();
      Future.delayed(const Duration(milliseconds: 1000), () {
//        showUser();
      });
    });
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
              showUserLayer();
              Future.delayed(const Duration(milliseconds: 1000), () {
//                showUser();
              });
              controller.enableCameraTracking(null, (msg) {
                if (msg['zoom'] >= 12 && markerType == MarkerType.POINT_SMALL) {
                  markerType = MarkerType.POINT_MEDIUM;
                  controller.changePlacemarksIcon(selectedPlaceMark, 'assets/point_red_medium.png');
                } else if (msg['zoom'] < 12 && markerType == MarkerType.POINT_MEDIUM) {
                  markerType = MarkerType.POINT_SMALL;
                  controller.changePlacemarksIcon(selectedPlaceMark, 'assets/point_red_small.png');
                }
              });
            },
          )),
        ]);
  }

  void showUser() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.moveToUser();
    } else {
//      _showMessage(context, const Text('Location permission was NOT granted'));
    }
  }

  void showPickPoints() {
    if (pickPointRepository.isLoaded) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        pickPointRepository.response.content.where((element) => element.address.contains("Москва")).forEach((element) {
          var _point = Point(latitude: double.parse(element.lat), longitude: double.parse(element.lon));
          final Placemark _placemark = Placemark(
            point: _point,
            opacity: 0.8,
            iconName: 'assets/point_red_small.png',
            onTap: (Placemark placemark, double latitude, double longitude) => {
              if (selectedPlaceMark != null){
                  controller.changePlacemarkIcon(
                      selectedPlaceMark,
                      markerType == MarkerType.POINT_MEDIUM
                          ? 'assets/point_red_medium.png'
                          : 'assets/point_red_small.png')},
              selectedPlaceMark = placemark,
              controller.changePlacemarkIcon(placemark, 'assets/point_red_large.png')
            },
          );
          placeMarks.add(_placemark);
          controller.addPlacemark(_placemark);
        });
      });
    }
  }

  void showUserLayer() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.showUserLayer(
          iconName: 'assets/user_location.png',
          arrowName: 'assets/user_location.png',
          accuracyCircleFillColor: Colors.green.withOpacity(0.5));
    } else {
//      _showMessage(context, const Text('Location permission was NOT granted'));
    }
  }

  void _showMessage(BuildContext context, Text text) {
    final ScaffoldState scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: text,
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
