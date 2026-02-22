import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestGeofencePermissions() async {

    var locationStatus = await Permission.locationWhenInUse.status;

    if (!locationStatus.isGranted) {
      locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) return false;
    }


    if (Platform.isAndroid) {
      var backgroundStatus = await Permission.locationAlways.status;

      if (!backgroundStatus.isGranted) {
        backgroundStatus = await Permission.locationAlways.request();

        if (!backgroundStatus.isGranted) {
          if (backgroundStatus.isPermanentlyDenied) {
            openAppSettings();
          }
          return false;
        }
      }
    }

 
    if (Platform.isAndroid) {
      var activityStatus = await Permission.activityRecognition.status;

      if (!activityStatus.isGranted) {
        activityStatus = await Permission.activityRecognition.request();

        if (!activityStatus.isGranted) {
          if (activityStatus.isPermanentlyDenied) {
            openAppSettings();
          }
          return false;
        }
      }
    }

    return true;
  }
}