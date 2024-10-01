import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Environment {
  static const baseUrl = 'https://apipre.bizne.com.mx/api/v13.2/';
  static const menuBaseUrl = 'https://menu.bizne.com.mx/';

  static const apiKey = "Bizne*2022!_";

  static const whatsappContact = '+525529475684';

  static const googleApiKey = 'AIzaSyCjOMPkc0bqoUvIfNZPA9D-A98G-gCSczU';

  static const appDefaultLanguage = 'es';

  static const appBundleId = 'mx.devbizne.bizne';

  static const spriteApiKey = 'pk_test_TZX4xTSTBKK1GwbTl7Wza9cv00cY9tcgu3';

  static const termsAndConditions =
      'https://newadmin.bizne.com.mx/#/documents/terms';

  static const privacyPolicy =
      'https://newadmin.bizne.com.mx/#/documents/privacy';

  static const isDebugMode = true;

  static const initialLocation = LatLng(19.432608, -99.133209);
}

var enviroments = Environment();

class Device {
  bool isMobile() => SizerUtil.deviceType == DeviceType.mobile;

  bool isTablet() => SizerUtil.deviceType == DeviceType.tablet;

  bool isPortrait() => SizerUtil.orientation == Orientation.portrait;

  bool isLandscape() => SizerUtil.orientation == Orientation.landscape;
}
