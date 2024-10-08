import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/home/view.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/service_details/controller.dart';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceDetailsPage extends LayoutRouteWidget<ServiceDetailsController> {
  const ServiceDetailsPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    Establishment establishment = params as Establishment;
    controller.isFavorite.call(establishment.favorite);

    final controllerWebView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppThemes().white)
      ..setNavigationDelegate(NavigationDelegate(
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
          }))
      ..loadRequest(Uri.parse(
          '${Environment.menuBaseUrl}?marca=${establishment.matrixId}&sucursal=${establishment.id}'));

    final titleContactArea =
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
          width: 70.w,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyText(
                text:
                    '${establishment.name} ${AppLocalizations.of(context)!.atDistance(Utils.formattedDistance(establishment.distance))}',
                type: FontType.bold,
                fontSize: 16.sp,
                color: AppThemes().primary)
          ])),
      IconButton(
          onPressed: () {
            FirebaseAnalytics.instance.logEvent(
              name: 'user_app_menu_help',
              parameters: {
                'type': 'button',
                'name': 'help',
                'store_id': establishment.id.toString()
              }
            );
            controller.contactBusiness(establishment.phone);
          },
          icon: Image.asset('assets/icons/phone.png', width: 10.w))
    ]);

    final selectArea = SizedBox(
        width: 100.w,
        child: Row(children: [
          TabItem(
              onTab: () => FirebaseAnalytics.instance
                      .logEvent(
                        name: 'user_app_menu_day_menu',
                        parameters: {
                          'type': 'button',
                          'name': 'day_menu',
                          'store_id': establishment.id.toString()
                        }
                      ),
              selected: true,
              text: AppLocalizations.of(context)!.menuOfDay),
          TabItem(
              onTab: () {
                FirebaseAnalytics.instance.logEvent(
                  name: 'user_app_menu_schedule',
                  parameters: {
                    'type': 'button',
                    'name': 'schedule',
                    'store_id': establishment.id.toString()
                  }
                );
                controller.navigate(restaurantDetails, params: establishment);
              },
              selected: false,
              text: AppLocalizations.of(context)!.schedule)
        ]));

    final bannerArea = Stack(children: [
      SizedBox(
          height: 25.h,
          width: 100.w,
          child: establishment.menuPic == null || establishment.menuPic!.isEmpty
              ? Image.network(establishment.pic!, fit: BoxFit.cover)
              : Image.network(establishment.menuPic!, fit: BoxFit.cover)),
      Positioned(
          bottom: 10.h,
          right: 5.w,
          child: InkWell(
              onTap: () => controller.setFavorite(establishment),
              child: Obx(() => Icon(
                    color: AppThemes().primary,
                    controller.isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 24.sp,
                  )))),
      Positioned(
          bottom: 0,
          child: Container(
              color: const Color.fromRGBO(247, 244, 244, 0.70),
              width: 100.w,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 0.5.h, left: 2.5.w, right: 2.5.w, bottom: 1.h),
                  child: titleContactArea)))
    ]);

    return Column(children: [
      bannerArea,
      selectArea,
      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: WebViewWidget(controller: controllerWebView))),
      Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 2.h),
          child: BizneElevatedButton(
              heightFactor: 0.04,
              title: AppLocalizations.of(context)!.pay,
              onPressed: () => controller.transactionData(establishment)))
    ]);
  }
}
