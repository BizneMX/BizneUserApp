import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/profiler_avatar.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/terms_and_conditions/controller.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsPage
    extends LayoutRouteWidget<TermsAndConditionController> {
  const TermsAndConditionsPage({super.key, super.params});

  Widget getButton(String title, Function() onPressed) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
        child: BizneElevatedButton(
          onPressed: onPressed,
          textSize: 14.sp,
          title: title,
          secondary: true,
          heightFactor: 0.04,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final user = params as User;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.h,
        ),
        ProfileAvatar(
            imageUrl: user.pic,
            placeholderImage: 'assets/images/default_profile.png',
            size: 8.h),
        SizedBox(
          height: 2.h,
        ),
        NameAndUserState(
          name: '${user.name} ${user.lastName}',
          verified: user.employeeValidated,
        ),
        SizedBox(
          height: 3.h,
        ),
        ...[
          (
            AppLocalizations.of(context)!.termsAndConditions,
            controller.termsAndConditions
          ),
          (
            AppLocalizations.of(context)!.noticeOfPrivacy,
            controller.privacyPolicy
          ),
        ].map((e) => getButton(e.$1, e.$2)),
      ],
    );
  }
}
