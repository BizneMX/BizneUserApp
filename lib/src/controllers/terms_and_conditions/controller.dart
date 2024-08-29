import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/web_view/view.dart';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:get/get.dart';

class TermsAndConditionController extends LayoutRouteController {
  void termsAndConditions() {
    Get.toNamed(webView,
        arguments: WebViewParams(
            title: getLocalizations()!.termsAndConditions,
            url: Environment.termsAndConditions));
  }

  void privacyPolicy() {
    Get.toNamed(webView,
        arguments: WebViewParams(
            title: getLocalizations()!.noticeOfPrivacy,
            url: Environment.privacyPolicy));
  }
}
