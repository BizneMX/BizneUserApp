import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/support/controller.dart';
import 'package:bizne_flutter_app/src/controllers/web_view/view.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/support_item.dart';

class SupportPage extends GetWidget<SupportController> {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getData(Get.arguments);
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
                    text: AppLocalizations.of(context)!.selectProblem,
                    color: AppThemes().primary,
                    fontSize: 16.sp,
                    type: FontType.semibold,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                itemCount: controller.data.length,
                itemBuilder: (buildContext, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                    child: SupportItemWidget(
                      onPressed: index == controller.data.length - 1
                          ? () async {
                              await Utils.contactSupport();
                            }
                          : () => Get.toNamed(webView,
                              arguments: WebViewParams(
                                  title: AppLocalizations.of(context)!.support,
                                  url: controller.data[index].url)),
                      item: controller.data[index],
                      key: Key(index.toString()),
                    ),
                  );
                })),
          )
        ]),
      ),
    );
  }
}

class SupportItemWidget extends StatelessWidget {
  final SupportItemModel item;
  final Function() onPressed;

  const SupportItemWidget(
      {super.key, required this.onPressed, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: AppThemes().white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.0),
                side: BorderSide(width: 2, color: AppThemes().secondary))),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Image.network(item.pic),
                )),
            Expanded(
                flex: 4,
                child: MyText(
                  fontSize: 12.sp,
                  type: FontType.semibold,
                  text: item.description,
                ))
          ],
        ),
      ),
    );
  }
}
