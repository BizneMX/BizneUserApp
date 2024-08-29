import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BizneWebView extends StatelessWidget {
  final currentParams = Get.arguments as WebViewParams;
  final cookieManager = WebviewCookieManager();
  final controller = WebViewController();

  BizneWebView({super.key});

  void _clearCacheAndLoadUrl(String url) async {
    await controller.clearCache();
    await cookieManager.clearCookies();
    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    // final currentParams = Get.arguments as WebViewParams;
    // final cookieManager = WebviewCookieManager();
    // final controller = WebViewController()
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppThemes().white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              EasyLoading.dismiss(animation: true);
            } else {
              if (!EasyLoading.isShow) EasyLoading.show();
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _clearCacheAndLoadUrl(currentParams.url);

    return Scaffold(
        body: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(children: [
              Stack(
                children: [
                  BizneBackButton(
                    onPressed: () => Get.back(),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.5.h),
                      child: MyText(
                        text: currentParams.title,
                        color: AppThemes().primary,
                        fontSize: 16.sp,
                        type: FontType.semibold,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: WebViewWidget(
                controller: controller,
              ))
            ])));
  }
}

class WebViewParams {
  final String title;
  final String url;

  const WebViewParams({required this.title, required this.url});
}
