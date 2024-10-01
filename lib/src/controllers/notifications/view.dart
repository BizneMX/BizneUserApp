import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/notifications/controller.dart';
import 'package:bizne_flutter_app/src/models/notification.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends LayoutRouteWidget<NotificationsController> {
  const NotificationsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    controller.getNotifications(clear: true);
    return Column(
      children: [
        SizedBox(
          height: 2.h,
        ),
        Expanded(
          child: Obx(() => controller.notNotifications.value
              ? Padding(
                  padding: EdgeInsets.only(top: 1.h, bottom: 3.h),
                  child: Center(
                    child: MyText(
                      fontSize: 12.sp,
                      color: AppThemes().primary,
                      text: AppLocalizations.of(context)!
                          .noNotificationsAvailable,
                      type: FontType.bold,
                    ),
                  ))
              : ListView.builder(
                  itemCount: controller.notifications.length +
                      (controller.total.value == controller.notifications.length
                          ? 0
                          : 1),
                  itemBuilder: (buildContext, index) {
                    if (index == controller.notifications.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: 1.h, bottom: 3.h),
                        child: Center(
                          child: MyRichText(
                              text: MyTextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.seeMore,
                                  color: AppThemes().primary,
                                  fontSize: 12.sp,
                                  text: AppLocalizations.of(context)!.seeMore,
                                  type: FontType.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: NotificationItem(
                              notification: controller.notifications[index]),
                        ),
                        SizedBox(
                          width: 80.w,
                          child: Divider(
                            color: AppThemes().grey.withOpacity(0.5),
                          ),
                        )
                      ],
                    );
                  })),
        )
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: notification.title,
              color: AppThemes().primary,
              type: FontType.bold,
              fontSize: 12.sp,
            ),
            MyText(
              text: LocalizationFormatters.dateFormat(notification.date),
              color: AppThemes().primary,
              fontSize: 9.sp,
            )
          ],
        ),
        MyText(
          fontSize: 11.sp,
          text: notification.description,
          color: AppThemes().primary,
        )
      ],
    );
  }
}
