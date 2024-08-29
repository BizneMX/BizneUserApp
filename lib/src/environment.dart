import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Environment {
  static const baseUrl = 'https://services.bizne.com.mx/api/v12.3/';

  static const menuBaseUrl = 'http://menu.bizne.com.mx/';

  static const apiKey = "Bizne*2022!_";

  static const whatsappContact = '+525529475684';

  static const googleApiKey = 'AIzaSyDakuTjAOjZKh6mxiTJ04-d6O-byXP3N9E';

  static const appDefaultLanguage = 'es';

  static const appBundleId = 'mx.devbizne.bizne';

  static const spriteApiKey = 'pk_live_DkvamrO5o9lxFEY2Q6RVyV1l00Vjb5ZanJ';

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
