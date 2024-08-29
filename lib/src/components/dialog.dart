import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/view.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../models/response.dart' as resp;

class BizneDialog extends StatelessWidget {
  final String text;
  final String? okText;
  final Function() onOk;
  final Function()? onCancel;

  const BizneDialog(
      {super.key,
      required this.text,
      required this.onOk,
      this.onCancel,
      this.okText});

  @override
  Widget build(BuildContext context) {
    final okTextLabel = okText ?? AppLocalizations.of(context)!.understood;
    final cancelButton = onCancel != null
        ? [
            SizedBox(height: 2.h),
            BizneElevatedButton(
                secondary: true,
                heightFactor: 0.04,
                onPressed: onCancel,
                title: AppLocalizations.of(context)!.cancel)
          ]
        : [];
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              MyText(
                  text: text,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              BizneElevatedButton(
                  heightFactor: 0.04, onPressed: onOk, title: okTextLabel),
              ...cancelButton
            ])));
  }
}

class BizneAppGoOutDialog extends StatelessWidget {
  final Function() onOk;
  final Function()? onCancel;

  const BizneAppGoOutDialog({super.key, required this.onOk, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        text: AppLocalizations.of(context)!.exitApp,
        onOk: onOk,
        onCancel: onCancel);
  }
}

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: 10.h,
          child: SizedBox(
              width: 100.w,
              child: Row(children: [
                const Expanded(child: SizedBox()),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                        color: AppThemes().white,
                        borderRadius: AppThemes().borderRadius),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyText(
                              text: AppLocalizations.of(context)!.noConnection,
                              type: FontType.bold),
                          SizedBox(width: 3.w),
                          Icon(Icons.no_sim, color: AppThemes().grey)
                        ])),
                const Expanded(child: SizedBox())
              ])))
    ]);
  }
}

class BizneDeleteAccountDialog extends StatefulWidget {
  final Function() onOk;
  final Function() gotToEditProfile;
  final Function() goToEditPhone;
  final Function() contactSupport;
  final Function()? onCancel;

  const BizneDeleteAccountDialog(
      {super.key,
      required this.onOk,
      required this.contactSupport,
      required this.goToEditPhone,
      required this.gotToEditProfile,
      this.onCancel});

  @override
  State<BizneDeleteAccountDialog> createState() =>
      _BizneDeleteAccountDialogState();
}

class _BizneDeleteAccountDialogState extends State<BizneDeleteAccountDialog> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final step0 = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyText(
          align: TextAlign.center,
          fontSize: 14.sp,
          text: AppLocalizations.of(context)!.areYouSureDeleteAccount,
          color: AppThemes().primary,
          type: FontType.bold,
        ),
        SizedBox(
          height: 2.h,
        ),
        MyText(
          align: TextAlign.center,
          text: AppLocalizations.of(context)!.deleteAccountQuestion,
          fontSize: 14.sp,
          color: AppThemes().primary,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 3.h,
        ),
        BizneElevatedButton(
            heightFactor: 0.04,
            onPressed: () {
              setState(() {
                step = 1;
              });
            },
            title: AppLocalizations.of(context)!.yesDelete),
        SizedBox(
          height: 2.h,
        ),
        BizneElevatedButton(
            secondary: true,
            heightFactor: 0.04,
            onPressed: widget.onCancel,
            title: AppLocalizations.of(context)!.cancel)
      ],
    );

    final step1 = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyText(
          align: TextAlign.center,
          fontSize: 14.sp,
          text: AppLocalizations.of(context)!.whatIsYourReason,
          color: AppThemes().primary,
          type: FontType.bold,
        ),
        SizedBox(
          height: 3.h,
        ),
        BizneElevatedButton(
            textSize: 12.sp,
            heightFactor: 0.04,
            onPressed: () {
              setState(() {
                step = 2;
              });
            },
            title: AppLocalizations.of(context)!.registeredWrong),
        SizedBox(
          height: 1.5.h,
        ),
        BizneElevatedButton(
            textSize: 12.sp,
            secondary: true,
            heightFactor: 0.04,
            onPressed: () {
              setState(() {
                step = 3;
              });
            },
            title: AppLocalizations.of(context)!.changedMyPhoneNumber),
        SizedBox(
          height: 1.5.h,
        ),
        BizneElevatedButton(
            textSize: 12.sp,
            secondary: true,
            heightFactor: 0.04,
            onPressed: widget.onOk,
            title: AppLocalizations.of(context)!.noLongerWishToHaveAnAccount),
        SizedBox(
          height: 3.h,
        ),
        BizneElevatedButton(
            secondary: true,
            heightFactor: 0.04,
            onPressed: widget.onCancel,
            title: AppLocalizations.of(context)!.cancel)
      ],
    );

    Widget finalStep(
        String text, String actionText, Function() actionFunction) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(
            color: AppThemes().primary,
            align: TextAlign.center,
            text: text,
            type: FontType.semibold,
            fontSize: 14.sp,
          ),
          SizedBox(
            height: 3.h,
          ),
          BizneElevatedButton(
              textSize: 12.sp,
              heightFactor: 0.04,
              onPressed: actionFunction,
              title: actionText),
          SizedBox(
            height: 1.5.h,
          ),
          BizneElevatedChildButton(
              secondary: true,
              heightFactor: 0.04,
              onPressed: widget.contactSupport,
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(0.8.h),
                      child: Image.asset('assets/icons/support_chat.png'),
                    )),
                Expanded(
                    flex: 3,
                    child: MyText(
                      type: FontType.semibold,
                      fontSize: 12.sp,
                      color: AppThemes().primary,
                      text: AppLocalizations.of(context)!.contactSupport,
                    ))
              ])),
          SizedBox(
            height: 1.5.h,
          ),
          BizneElevatedButton(
              color: AppThemes().primary,
              textSize: 12.sp,
              secondary: true,
              heightFactor: 0.04,
              onPressed: widget.onCancel,
              title: AppLocalizations.of(context)!.understood),
        ],
      );
    }

    Widget getStep() {
      switch (step) {
        case 0:
          return step0;
        case 1:
          return step1;
        case 2:
          return finalStep(
              AppLocalizations.of(context)!.registeredWithIncorrectData,
              AppLocalizations.of(context)!.goToEditProfile,
              widget.gotToEditProfile);
        case 3:
          return finalStep(
              AppLocalizations.of(context)!.changedYourPhoneNumber,
              AppLocalizations.of(context)!.goToEditPhone,
              widget.goToEditPhone);

        default:
          return const SizedBox();
      }
    }

    return Center(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      decoration: BoxDecoration(
          color: AppThemes().background,
          borderRadius: AppThemes().borderRadius),
      width: 80.w,
      child: getStep(),
    ));
  }
}

class BizneOnlyConsumptionWeekDialog extends StatelessWidget {
  final Function() onOk;
  final Function()? onCancel;
  const BizneOnlyConsumptionWeekDialog(
      {super.key, required this.onOk, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: onOk,
        onCancel: onCancel,
        text: AppLocalizations.of(context)!.onlyConsumptionWeek);
  }
}

class BizneChangePasswordDialog extends StatelessWidget {
  final Function() onOk;
  final Function()? onCancel;
  const BizneChangePasswordDialog(
      {super.key, required this.onOk, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: onOk,
        onCancel: onCancel,
        text: AppLocalizations.of(context)!.passwordChangedSuccessfully);
  }
}

class BizneUpdatedPhoneDialog extends StatelessWidget {
  final Function() onOk;
  final Function()? onCancel;
  const BizneUpdatedPhoneDialog({super.key, required this.onOk, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: onOk,
        onCancel: onCancel,
        text: AppLocalizations.of(context)!.updatedPhone);
  }
}

class BizneAreYouSureToDeleteCreditCardDialog extends StatelessWidget {
  final Function() onOk;
  final Function() onCancel;
  const BizneAreYouSureToDeleteCreditCardDialog(
      {super.key, required this.onOk, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: onOk,
        onCancel: () => Get.back(),
        text: AppLocalizations.of(context)!.areYouSureToDeleteCreditCard);
  }
}

class BizneRemovedCreditCardDialog extends StatelessWidget {
  const BizneRemovedCreditCardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: () => Get.back(),
        text: AppLocalizations.of(context)!.removedCreditCard);
  }
}

class BizneAddedCreditCardDialog extends StatelessWidget {
  const BizneAddedCreditCardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        onOk: () => Get.back(),
        text: AppLocalizations.of(context)!.creditCardAddedSuccessfully);
  }
}

class ReportWasSentDialog extends StatelessWidget {
  final HistoryFood historyFood;
  const ReportWasSentDialog({super.key, required this.historyFood});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Center(
                child: Container(
                  height: 50.sp,
                  width: 50.sp,
                  decoration: BoxDecoration(
                    borderRadius: AppThemes().borderRadius,
                  ),
                  child: Image.network(historyFood.pic),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              MyText(
                  text: AppLocalizations.of(context)!.reportWasSent,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  fontSize: 16.sp),
              MyText(
                  text: historyFood.estabName,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              MyText(
                  text: AppLocalizations.of(context)!.sorryBadExperience,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () => Get.back(),
                  title: AppLocalizations.of(context)!.understood),
            ])));
  }
}

class RateServiceDialog extends StatelessWidget {
  final String name;
  final String pic;
  const RateServiceDialog({super.key, required this.name, required this.pic});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Center(
                child: Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration:
                      BoxDecoration(borderRadius: AppThemes().borderRadius),
                  child: Image.network(pic),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              MyText(
                  text: AppLocalizations.of(context)!.thanksForRating,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  fontSize: 16.sp),
              MyText(
                  text: name,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () => Get.back(),
                  title: AppLocalizations.of(context)!.close),
            ])));
  }
}

class BizneAreYouSureCloseThisScreen extends StatelessWidget {
  final Function() onOk;
  const BizneAreYouSureCloseThisScreen({
    super.key,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              MyText(
                  text: AppLocalizations.of(context)!.areYouSureCloseScreen,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(
                height: 2.h,
              ),
              MyText(
                  text: AppLocalizations.of(context)!.makeSureYouHaveShown,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 4.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: onOk,
                  title: AppLocalizations.of(context)!.continueText),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: () => Get.back(),
                  title: AppLocalizations.of(context)!.cancel)
            ])));
  }
}

class BizneResponseErrorDialog extends StatelessWidget {
  final resp.ResponseRepository response;
  const BizneResponseErrorDialog({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    if (response.invalidToken) {
      return BizneDialog(
          text: AppLocalizations.of(context)!.expiredToken,
          onOk: () async {
            Get.back();
            final sharedPref = await SharedPreferences.getInstance();
            await sharedPref.remove('token');

            Get.offNamed(welcome, arguments: false);
          });
    }

    return BizneDialog(
        text: response.message ?? AppLocalizations.of(context)!.unexpectedError,
        onOk: () => Get.back());
  }
}

class BizneLoginErrorDialog extends StatelessWidget {
  const BizneLoginErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        text: AppLocalizations.of(context)!.ifYouWereAlreadyRegistered,
        onOk: () async {
          await Utils.contactSupport();
        },
        onCancel: () => Get.back(),
        okText: AppLocalizations.of(context)!.contactSupport);
  }
}

class BizneNotResendCode extends StatelessWidget {
  const BizneNotResendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        text: AppLocalizations.of(context)!.notResendCode,
        onOk: () => Get.back());
  }
}

class BizneMyBizneDialog extends StatelessWidget {
  const BizneMyBizneDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              MyText(
                  text: AppLocalizations.of(context)!.info,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                        child: const MyBizneVerified(verified: true),
                      )),
                  Expanded(
                      flex: 2,
                      child: MyText(
                          fontSize: 12.sp,
                          color: AppThemes().primary,
                          text: AppLocalizations.of(context)!
                              .myBizneVerifiedInfo))
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.sp, right: 10.sp),
                        child: const MyBizneVerified(verified: false),
                      )),
                  Expanded(
                      flex: 2,
                      child: MyText(
                          fontSize: 12.sp,
                          color: AppThemes().primary,
                          text: AppLocalizations.of(context)!
                              .myBizneNotVerifiedInfo))
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              MyText(
                  fontSize: 12.sp,
                  color: AppThemes().primary,
                  text: AppLocalizations.of(context)!.ifYouDoNotHaveBzCoins),
              SizedBox(
                height: 3.h,
              ),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () => Get.back(),
                  title: AppLocalizations.of(context)!.understood),
              SizedBox(
                height: 2.h,
              ),
              BizneElevatedChildButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: () => Get.back(),
                  child: Row(children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(0.8.h),
                          child: Image.asset('assets/icons/support_chat.png'),
                        )),
                    Expanded(
                        flex: 5,
                        child: MyText(
                          type: FontType.semibold,
                          fontSize: 16.sp,
                          color: AppThemes().primary,
                          text: AppLocalizations.of(context)!.contactSupport,
                        ))
                  ])),
            ])));
  }
}

class RegisterCompleteDialog extends StatelessWidget {
  const RegisterCompleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        text: AppLocalizations.of(context)!.completeAllFields,
        onOk: () => Get.back());
  }
}

class EstablishmentClosedDialog extends StatelessWidget {
  const EstablishmentClosedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneDialog(
        text: AppLocalizations.of(context)!.establishmentClosed,
        onOk: () => Get.back());
  }
}

class SelectAmountDialog extends StatelessWidget {
  final Widget selectArea;
  final Function() continueButton;
  final Function() cancelButton;
  const SelectAmountDialog(
      {super.key,
      required this.selectArea,
      required this.continueButton,
      required this.cancelButton});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              MyText(
                  text: AppLocalizations.of(context)!.selectAmountPay,
                  align: TextAlign.center,
                  color: AppThemes().primary,
                  type: FontType.bold,
                  fontSize: 16.sp),
              SizedBox(height: 3.h),
              selectArea,
              SizedBox(height: 3.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: continueButton,
                  title: AppLocalizations.of(context)!.continueText),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: cancelButton,
                  title: AppLocalizations.of(context)!.cancel)
            ])));
  }
}
