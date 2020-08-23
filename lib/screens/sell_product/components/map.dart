import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refashioned_app/repositories/pick_point.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatelessWidget {
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
  PickPointRepository pickPointRepository;

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
        showUser();
      });
    });
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
                showUser();
              });
            },
          )),
        ]);
  }

  void showUser() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.moveToUser();
//      Future.delayed(const Duration(milliseconds: 2500), () {
//        moveToUser();
//      });
    } else {
//      _showMessage(context, const Text('Location permission was NOT granted'));
    }
  }

  void showPickPoints() {
    if (pickPointRepository.isLoaded) {
      Future.delayed(const Duration(milliseconds: 2500), () {
        pickPointRepository.response.content.where((element) => element.address.contains("Москва")).forEach((element) {
          var _point = Point(latitude: double.parse(element.lat), longitude: double.parse(element.lon));
          final Placemark _placemark = Placemark(
            point: _point,
            opacity: 0.8,
            iconName: 'assets/pick_point.png',
            onTap: (double latitude, double longitude) => print('Tapped me at $latitude,$longitude'),
          );
          placeMarks.add(_placemark);
          controller.addPlacemark(_placemark);
        });
      });
    }
  }

  void addPlaceMark() {}

//  void moveToUser() async {
//    if (_permissionStatus == PermissionStatus.granted) {
//      await controller.move(
//          point: await controller.getTargetPoint(), animation: const MapAnimation(smooth: true, duration: 2.0));
//    } else {
////      _showMessage(context, const Text('Location permission was NOT granted'));
//    }
//  }

  void showUserLayer() async {
    if (_permissionStatus == PermissionStatus.granted) {
      await controller.showUserLayer(
          iconName: 'assets/place.png',
          arrowName: 'assets/place.png',
          accuracyCircleFillColor: Colors.green.withOpacity(0.5));
    } else {
//      _showMessage(context, const Text('Location permission was NOT granted'));
    }
  }
}
