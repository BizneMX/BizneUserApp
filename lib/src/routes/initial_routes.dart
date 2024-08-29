import 'package:bizne_flutter_app/src/controllers/permissions/binding.dart';
import 'package:bizne_flutter_app/src/controllers/permissions/view.dart';
import 'package:bizne_flutter_app/src/controllers/splash/binding.dart';
import 'package:bizne_flutter_app/src/controllers/splash/view.dart';
import 'package:bizne_flutter_app/src/controllers/support/binding.dart';
import 'package:bizne_flutter_app/src/controllers/support/view.dart';
import 'package:bizne_flutter_app/src/controllers/web_view/view.dart';
import 'package:get/get.dart';

import '../constants/routes.dart';

class InitialPages {
  static List<GetPage> pages = [
    GetPage(
        name: splash, page: () => const SplashPage(), binding: SplashBinding()),
    GetPage(name: welcome, page: () => const WelcomePage()),
    GetPage(
        name: permissions,
        page: () => const PermissionPage(),
        binding: PermissionBinding()),
    GetPage(
        name: support,
        page: () => const SupportPage(),
        binding: SupportBinding()),
    GetPage(name: webView, page: () => BizneWebView())
  ];
}
