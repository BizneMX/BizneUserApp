// ignore_for_file: use_build_context_synchronously

import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/web_view/view.dart';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:bizne_flutter_app/src/models/organization.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../components/buttons.dart';
import '../../components/text_filed.dart';
import 'controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildPage() {
      FirebaseAnalytics.instance.logEvent(
        name: 'user_app_registration_step_${controller.selectedPage.value + 1}'
      );
      switch (controller.selectedPage.value) {
        case 0:
          return NamePage(nextPage: () => controller.nextPage());
        case 1:
          return EmailPage(nextPage: () => controller.nextPage());
        case 2:
          return const GenrePage();
        case 3:
          return const OrganizationPage();
        default:
          return NamePage(nextPage: () => controller.nextPage());
      }
    }

    final whileRegister =
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      BizneElevatedButton(
          onPressed: () async {
            await FirebaseAnalytics.instance.logEvent(
              name: 'user_app_registration',
              parameters: {
                'type': 'button',
                'step': '${controller.selectedPage.value + 1}',
                'name': 'continue'
              }
            );
            controller.nextPage();
          },
          title: AppLocalizations.of(context)!.continueText),
      SizedBox(height: 3.h),
      BizneSupportButton(analyticsCallFunction: () async {
        FirebaseAnalytics.instance.logEvent(
          name: 'user_app_registration',
          parameters: {
            'type': 'button',
            'step': '${controller.selectedPage.value + 1}',
            'name': 'help'
          }
        );
      }),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyText(
            text: AppLocalizations.of(context)!.alreadyHaveAccount,
            type: FontType.regular,
            fontSize: 13.sp,
            color: AppThemes().primary),
        TextButton(
            onPressed: () => controller.goToLogin(),
            child: MyText(
                text: AppLocalizations.of(context)!.startSession,
                fontSize: 13.sp,
                type: FontType.bold,
                decoration: TextDecoration.underline,
                color: AppThemes().primary))
      ])
    ]);

    final termAndConditions = MyRichText(
        align: TextAlign.center,
        text: MyTextSpan(
            text: AppLocalizations.of(context)!.aceptTermsAndConditionsText1,
            color: AppThemes().primary,
            children: [
              MyTextSpan(
                  text: AppLocalizations.of(context)!
                      .aceptTermsAndConditionsText2,
                  color: AppThemes().secondary,
                  decoration: TextDecoration.underline,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(webView,
                        arguments: WebViewParams(
                            title: AppLocalizations.of(context)!
                                .termsAndConditions,
                            url: Environment.termsAndConditions))),
              MyTextSpan(
                  text: AppLocalizations.of(context)!
                      .aceptTermsAndConditionsText3),
              MyTextSpan(
                  text: AppLocalizations.of(context)!
                      .aceptTermsAndConditionsText4,
                  color: AppThemes().secondary,
                  decoration: TextDecoration.underline,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(webView,
                        arguments: WebViewParams(
                            title:
                                AppLocalizations.of(context)!.noticeOfPrivacy,
                            url: Environment.privacyPolicy)))
            ]));

    final afterRegister = Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Column(children: [
          Center(child: termAndConditions),
          SizedBox(
            height: 2.h,
          ),
          BizneElevatedButton(
              onPressed: () => controller.register(),
              title: AppLocalizations.of(context)!.finish),
          SizedBox(height: 3.h),
          BizneSupportButton(analyticsCallFunction: () async {
            FirebaseAnalytics.instance.logEvent(
              name: 'user_app_registration',
              parameters: {
                'type': 'button',
                'name': 'after_help'
              }
            );
          })
        ]));

    final buttonArea = Obx(() => controller.selectedPage.value == 3
        ? (controller.lastPage() ? afterRegister : const SizedBox())
        : whileRegister);

    final superiorBar = SizedBox(
        height: 6.h,
        width: 100.w,
        child: Stack(children: [
          Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i in [0, 1, 2, 3])
              Obx(() => Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: 3.5.w,
                  decoration: BoxDecoration(
                      color: i == controller.selectedPage.value
                          ? AppThemes().primary
                          : AppThemes().grey.withOpacity(0.5),
                      shape: BoxShape.circle)))
          ])),
          Row(children: [
            BizneBackButton(onPressed: () => controller.previousPage())
          ])
        ]));

    return PopScope(
        canPop: false,
        onPopInvoked: (a) => controller.previousPage(),
        child: Scaffold(
          body: Column(children: [
            superiorBar,
            Expanded(
                child: Obx(() => SizedBox(width: 90.w, child: buildPage()))),
            SizedBox(width: 80.w, child: buttonArea)
          ]),
        ));
  }
}

class NamePage extends GetWidget<NameFormController> {
  final void Function() nextPage;
  const NamePage({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 70.h,
            child: Column(children: [
              MyText(
                  text: AppLocalizations.of(context)!.whatIsYourName,
                  fontSize: 18.sp,
                  color: AppThemes().primary,
                  type: FontType.bold),
              SizedBox(height: 1.h),
              SizedBox(
                  height: 25.h,
                  child: Image.asset('assets/images/register_name.png')),
              Container(
                  margin: EdgeInsets.only(top: 3.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: MyText(
                                text: AppLocalizations.of(context)!.name,
                                fontSize: 14.sp,
                                color: AppThemes().primary,
                                type: FontType.bold)),
                        BizneTextFormField(
                            textInputAction: TextInputAction.next,
                            key: controller.formKeys['name']!,
                            textAlign: TextAlign.center,
                            controller: controller.controllers['name']!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .nameRequired;
                              }
                              return null;
                            },
                            onSubmited: (() {})),
                        SizedBox(height: 2.h),
                        Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: MyText(
                                text: AppLocalizations.of(context)!.lastName,
                                fontSize: 14.sp,
                                color: AppThemes().primary,
                                type: FontType.bold)),
                        BizneTextFormField(
                            key: controller.formKeys['lastname']!,
                            textAlign: TextAlign.center,
                            controller: controller.controllers['lastname']!,
                            validator: (value) {
                              final splitted = value!.split(' ');
                              if (splitted.length < 2 || splitted[1].isEmpty) {
                                return AppLocalizations.of(context)!
                                    .shouldIncludeBothLastNames;
                              }
                              return null;
                            },
                            onSubmited: (() => nextPage()))
                      ]))
            ])));
  }
}

class EmailPage extends GetWidget<EmailFormController> {
  final void Function() nextPage;
  const EmailPage({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 70.h,
            child: Column(children: [
              MyText(
                  text: AppLocalizations.of(context)!.whatIsYourEmail,
                  fontSize: 18.sp,
                  color: AppThemes().primary,
                  type: FontType.bold),
              SizedBox(height: 1.h),
              SizedBox(
                  height: 25.h,
                  child: Image.asset('assets/images/register_email.png')),
              Container(
                  margin: EdgeInsets.only(top: 3.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: MyText(
                                text: AppLocalizations.of(context)!.email,
                                fontSize: 14.sp,
                                color: AppThemes().primary,
                                type: FontType.bold)),
                        BizneTextFormField(
                            textInputAction: TextInputAction.next,
                            key: controller.formKeys['email']!,
                            suffixError: true,
                            textAlign: TextAlign.center,
                            controller: controller.controllers['email']!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .emailRequired;
                              } else if (!GetUtils.isEmail(value)) {
                                return AppLocalizations.of(context)!
                                    .emailInvalid;
                              }
                              return null;
                            },
                            onSubmited: (() {})),
                        SizedBox(height: 3.h),
                        Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: MyText(
                                text: AppLocalizations.of(context)!.setPassword,
                                fontSize: 14.sp,
                                color: AppThemes().primary,
                                type: FontType.bold)),
                        BizneTextFormField(
                            textInputAction: TextInputAction.next,
                            key: controller.formKeys['password']!,
                            isPassword: true,
                            controller: controller.controllers['password']!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .passwordRequired;
                              } else if (value.length < 6) {
                                return AppLocalizations.of(context)!
                                    .passwordLength;
                              }
                              return null;
                            },
                            onSubmited: (() {})),
                        SizedBox(height: 1.h),
                        Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: MyText(
                                text: AppLocalizations.of(context)!
                                    .confirmPassword,
                                fontSize: 14.sp,
                                color: AppThemes().primary,
                                type: FontType.bold)),
                        BizneTextFormField(
                            key: controller.formKeys['confirmPassword']!,
                            isPassword: true,
                            controller:
                                controller.controllers['confirmPassword']!,
                            validator: (value) {
                              if (!controller.isPasswordValid) {
                                return AppLocalizations.of(context)!
                                    .passwordsDontMatch;
                              }
                              return null;
                            },
                            onSubmited: (() => nextPage()))
                      ]))
            ])));
  }
}

class GenrePage extends GetWidget<BirthdateFormController> {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 70.h,
        child: Column(children: [
          MyText(
              text: AppLocalizations.of(context)!.weWantToKnowMore,
              fontSize: 18.sp,
              color: AppThemes().primary,
              type: FontType.bold),
          SizedBox(height: 1.h),
          SizedBox(
              height: 25.h,
              child: Image.asset('assets/images/register_birthdate.png')),
          Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 2.5.w),
                        child: MyText(
                            text: AppLocalizations.of(context)!.birthday,
                            fontSize: 14.sp,
                            color: AppThemes().primary,
                            type: FontType.bold)),
                    BizneTextFormField(
                        textInputAction: TextInputAction.none,
                        key: controller.formKeys['birthdate']!,
                        textAlign: TextAlign.center,
                        controller: controller.controllers['birthdate']!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return null;
                          } else if (!controller.validDate()) {
                            return AppLocalizations.of(context)!
                                .birthdayInvalid;
                          }
                          return null;
                        },
                        hint: '__/__/____',
                        isNumber: true,
                        onSubmited: () {}),
                    SizedBox(height: 3.h),
                    Padding(
                        padding: EdgeInsets.only(left: 2.5.w),
                        child: MyText(
                            text: AppLocalizations.of(context)!.genre,
                            fontSize: 14.sp,
                            color: AppThemes().primary,
                            type: FontType.bold)),
                    SizedBox(height: 1.h),
                    SizedBox(height: 10.h, child: const GenreSelector())
                  ]))
        ]),
      ),
    );
  }
}

class GenreSelector extends GetWidget<GenreController> {
  const GenreSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = [
      {'label': AppLocalizations.of(context)!.female, 'icon': Icons.female},
      {'label': AppLocalizations.of(context)!.male, 'icon': Icons.male},
      {'label': AppLocalizations.of(context)!.other, 'icon': Icons.male}
    ];

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      for (int i = 0; i < genres.length; i++) _genreButton(genres[i], i)
    ]);
  }

  Widget _genreButton(Map<String, dynamic> genre, int index) {
    return Obx(() {
      bool selected = controller.selectedGenre.value == index;
      return ElevatedButton(
          onPressed: () => controller.setGenre(index),
          style: ElevatedButton.styleFrom(
              side: BorderSide(
                  color:
                      selected ? AppThemes().secondary : AppThemes().background,
                  width: selected ? 1.w : 0),
              surfaceTintColor: AppThemes().background,
              shape: RoundedRectangleBorder(
                  borderRadius: AppThemes().borderRadius)),
          child: SizedBox(
              child: Column(children: [
            Center(
                child: Icon((genre['icon'] as IconData),
                    size: 40.sp,
                    color:
                        selected ? AppThemes().secondary : AppThemes().grey)),
            MyText(
                text: genre['label'],
                fontSize: 10.sp,
                color: selected ? AppThemes().secondary : AppThemes().grey,
                type: FontType.bold)
          ])));
    });
  }
}

class OrganizationPage extends GetWidget<OrganizationController> {
  const OrganizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final noDecision = SizedBox(
        height: 70.h,
        child: Column(children: [
          MyText(
              text: '1. ${AppLocalizations.of(context)!.belongOrganization}',
              color: AppThemes().primary,
              fontSize: 16.sp,
              type: FontType.bold),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                _decisionButton(AppLocalizations.of(context)!.yes,
                    'assets/icons/organization_building.png', () async {
                  final bool organizationSelected =
                      (await _organizationDialog(context)) ?? false;
                  if (organizationSelected &&
                      controller.organizationIsSelected()) {
                    controller.setIsOrganization(true);
                  }
                }),
                _decisionButton(
                    AppLocalizations.of(context)!.no,
                    'assets/icons/no_organization.png',
                    () => controller.setIsOrganization(false))
              ]))
        ]));

    final decision = Obx(() => SizedBox(
        height: 60.h,
        child: Column(children: [
          SizedBox(
              width: 80.w,
              child: MyText(
                  text: '1. ${AppLocalizations.of(context)!.organization}',
                  color: AppThemes().primary,
                  fontSize: 16.sp,
                  type: FontType.bold)),
          SizedBox(height: 1.h),
          Column(children: [
            Material(
                borderRadius: AppThemes().borderRadius,
                elevation: 4,
                child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                        color: AppThemes().background,
                        border: Border.all(
                            color: AppThemes().secondary, width: 1.w),
                        borderRadius: AppThemes().borderRadius),
                    height: 15.h,
                    width: 15.h,
                    child: Center(
                        child: controller.selectedOrganization.value.pic == null
                            ? Image.asset(
                                'assets/icons/organization_building.png')
                            : Image.network(
                                controller.selectedOrganization.value.pic!)))),
            SizedBox(height: 1.h),
            MyText(
                text: controller.selectedOrganization.value.name,
                color: AppThemes().secondary,
                fontSize: 14.sp,
                type: FontType.bold)
          ]),
          SizedBox(height: 1.h),
          SizedBox(
            width: 80.w,
            child: MyText(
                text:
                    '2. ${AppLocalizations.of(context)!.sectorSeccionSucursal}',
                color: AppThemes().primary,
                fontSize: 16.sp,
                type: FontType.bold),
          ),
          SizedBox(height: 1.h),
          SizedBox(
              width: 70.w,
              child: ElevatedButton(
                  onPressed: () => _sectorDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes().whiteInputs,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppThemes().borderRadius)),
                  child: SizedBox(
                      width: 70.w,
                      child: Center(
                          child: MyText(
                              text: controller.sector.value.isEmpty
                                  ? AppLocalizations.of(context)!.sectorAsterisk
                                  : controller.sector.value,
                              color: AppThemes().grey,
                              fontSize: 12.sp,
                              type: FontType.bold))))),
          SizedBox(height: 1.h),
          ...controller.selectedOrganization.value.validateField != null
              ? [
                  SizedBox(
                      width: 80.w,
                      child: MyText(
                          text:
                              '3. ${AppLocalizations.of(context)!.employeeNumber}',
                          color: AppThemes().primary,
                          fontSize: 16.sp,
                          type: FontType.bold)),
                  SizedBox(height: 1.h),
                  SizedBox(
                    height: 6.h,
                    width: 70.w,
                    child: ElevatedButton(
                        onPressed: () => _employeeNumberDialog(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes().whiteInputs,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppThemes().borderRadius)),
                        child: SizedBox(
                            width: 70.w,
                            child: Center(
                                child: MyText(
                                    text: controller
                                            .employeeNumber.value.isEmpty
                                        ? '${controller.selectedOrganization.value.validateField}*'
                                        : controller.employeeNumber.value,
                                    color: AppThemes().grey,
                                    fontSize: 12.sp,
                                    type: FontType.bold)))),
                  )
                ]
              : []
        ])));

    return SingleChildScrollView(
      child: SizedBox(
        height: 100.h,
        child: Column(children: [
          MyText(
              text: AppLocalizations.of(context)!.finishRegistration,
              fontSize: 18.sp,
              color: AppThemes().primary,
              type: FontType.bold),
          SizedBox(height: 5.h),
          Obx(() => controller.decision.value ? decision : noDecision)
        ]),
      ),
    );
  }

  Future<bool?> _sectorDialog(BuildContext context) async {
    final sectors = await controller.getSectors();
    return await Get.dialog(Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            height: 60.h,
            child: Column(children: [
              MyText(
                  align: TextAlign.center,
                  text: AppLocalizations.of(context)!
                      .selectSector(controller.selectedOrganization.value.name),
                  color: AppThemes().primary,
                  fontSize: 14.sp,
                  type: FontType.bold),
              SizedBox(height: 1.h),
              Expanded(
                child: SectorSearcher(
                    sectors: sectors, onChange: controller.setSector),
              ),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () async {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'user_app_registration_organization_select',
                      parameters: {
                        'type': 'button',
                        'step': '4',
                        'name': 'select'
                      }
                    );
                    Get.back(result: true);
                  },
                  title: AppLocalizations.of(context)!.select),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: () async {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'user_app_registration',
                      parameters: {
                        'type': 'button',
                        'step': '${controller.selectedPage.value + 1}',
                        'name': 'back'
                      }
                    );
                    Get.back(result: false);
                  },
                  title: AppLocalizations.of(context)!.returnText)
            ]))));
  }

  Future<bool?> _employeeNumberDialog(BuildContext context) async {
    final textController = TextEditingController();
    return await Get.dialog(Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            height: 35.h,
            child: Column(children: [
              MyText(
                  align: TextAlign.center,
                  text: AppLocalizations.of(context)!.employeeNumber,
                  color: AppThemes().primary,
                  fontSize: 16.sp,
                  type: FontType.bold),
              SizedBox(height: 1.h),
              MyText(
                  align: TextAlign.center,
                  text: AppLocalizations.of(context)!.enterEmployeeNumber,
                  color: AppThemes().primary,
                  fontSize: 12.sp,
                  type: FontType.bold),
              SizedBox(height: 2.h),
              BizneTextFormField(
                  hint: AppLocalizations.of(context)!.employeeNumber,
                  controller: textController,
                  textAlign: TextAlign.center,
                  validator: (value) => null,
                  onSubmited: () {}),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () {
                    controller.employeeNumber.value = textController.text;
                    Get.back(result: true);
                  },
                  title: AppLocalizations.of(context)!.confirm),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: () => Get.back(result: false),
                  title: AppLocalizations.of(context)!.returnText)
            ]))));
  }

  Future<bool?> _organizationDialog(BuildContext context) async {
    controller.getOrganizations();
    return await Get.dialog(Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: AppThemes().borderRadius),
            width: 80.w,
            height: 80.h,
            child: Column(children: [
              MyText(
                  text: AppLocalizations.of(context)!.selectYourOrganization,
                  color: AppThemes().primary,
                  fontSize: 16.sp,
                  type: FontType.bold),
              SizedBox(height: 1.h),
              Expanded(
                  child: OrganizationSearcher(
                      organizations: controller.organizations,
                      onChange: controller.setOrganization)),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  heightFactor: 0.04,
                  onPressed: () => Get.back(result: true),
                  title: AppLocalizations.of(context)!.select),
              SizedBox(height: 2.h),
              BizneElevatedButton(
                  secondary: true,
                  heightFactor: 0.04,
                  onPressed: () => Get.back(result: false),
                  title: AppLocalizations.of(context)!.returnText)
            ]))));
  }

  Widget _decisionButton(String text, String imagePath, Function() onPressed) {
    return Column(children: [
      ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: AppThemes().borderRadius),
              side: BorderSide(color: AppThemes().secondary, width: 1.w)),
          child: SizedBox(
              height: 20.h,
              width: 20.h,
              child: Center(child: Image.asset(imagePath, height: 60.sp)))),
      SizedBox(height: 1.h),
      MyText(
          text: text,
          color: AppThemes().secondary,
          fontSize: 18.sp,
          type: FontType.bold)
    ]);
  }
}

class SectorSearcher extends StatefulWidget {
  final void Function(Sector) onChange;
  final List<Sector> sectors;
  const SectorSearcher(
      {super.key, required this.onChange, required this.sectors});

  @override
  State<SectorSearcher> createState() => _SectorSearcherState();
}

class _SectorSearcherState extends State<SectorSearcher> {
  final textController = TextEditingController();
  int selected = -1;

  @override
  void initState() {
    textController.addListener(() {
      setState(() {
        selected = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sectors = widget.sectors
        .where((element) => element.name
            .toLowerCase()
            .contains(textController.text.toLowerCase()))
        .toList();

    return Column(children: [
      BizneTextFormField(
          prefixIcon: Icon(Icons.search, color: AppThemes().primary),
          hint: AppLocalizations.of(context)!.search,
          controller: textController,
          validator: (value) => null,
          onSubmited: () {}),
      SizedBox(height: 2.h),
      SizedBox(
          height: 20.h,
          child: SingleChildScrollView(
              child: Column(children: [
            for (int i = 0; i < sectors.length; i++)
              _sectorButton(sectors[i], selected == i, () {
                setState(() {
                  widget.onChange(sectors[i]);
                  selected = i;
                });
              })
          ])))
    ]);
  }

  Widget _sectorButton(Sector sector, bool selected, void Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(1.h),
            width: 70.w,
            color: selected ? AppThemes().whiteInputs : AppThemes().background,
            child: MyText(
                text: sector.name,
                color: AppThemes().primary,
                fontSize: 14.sp,
                type: FontType.bold)));
  }
}

class OrganizationSearcher extends StatefulWidget {
  final void Function(Organization) onChange;
  final List<Organization> organizations;
  final int selectedOrganization;
  const OrganizationSearcher(
      {super.key,
      required this.organizations,
      required this.onChange,
      this.selectedOrganization = -1});

  @override
  State<OrganizationSearcher> createState() => _OrganizationSearcherState();
}

class _OrganizationSearcherState extends State<OrganizationSearcher> {
  final textController = TextEditingController();
  int selected = 0;

  @override
  void initState() {
    setState(() {
      for (var i = 0; i < widget.organizations.length; i++) {
        if (widget.organizations[i].id == widget.selectedOrganization) {
          selected = i + 1;
          break;
        }
      }
    });

    textController.addListener(() {
      setState(() {
        selected = 1;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final organizations = [Organization(id: -1, name: '')] +
        widget.organizations
            .where((element) => element.name
                .toLowerCase()
                .contains(textController.text.toLowerCase()))
            .toList();

    return Column(children: [
      BizneTextFormField(
          prefixIcon: Icon(Icons.search, color: AppThemes().primary),
          hint: AppLocalizations.of(context)!.search,
          controller: textController,
          validator: (value) => null,
          onSubmited: () {}),
      SizedBox(height: 2.h),
      SizedBox(
          height: 50.h,
          child: SingleChildScrollView(
              child: Column(children: [
            for (int i = 0; i < organizations.length / 3; i++)
              Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int j = 0;
                            i * 3 + j < organizations.length && j < 3;
                            j++)
                          Column(children: [
                            _organizationButton(
                                organizations[i * 3 + j], selected == i * 3 + j,
                                () {
                              setState(() {
                                widget.onChange(organizations[i * 3 + j]);
                                selected = i * 3 + j;
                              });
                            }),
                            SizedBox(height: 1.h),
                            SizedBox(
                                width: 10.h,
                                child: MyText(
                                    align: TextAlign.center,
                                    text: organizations[i * 3 + j].name,
                                    color: AppThemes().secondary,
                                    fontSize: 10.sp,
                                    type: FontType.bold))
                          ])
                      ]))
          ])))
    ]);
  }

  Widget _organizationButton(
      Organization organization, bool selected, void Function() onTap) {
    return Material(
        borderRadius: AppThemes().borderRadius,
        elevation: 4,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                  color: AppThemes().background,
                  border: Border.all(
                      color: selected
                          ? AppThemes().secondary
                          : AppThemes().background,
                      width: 1.w),
                  borderRadius: AppThemes().borderRadius),
              height: 10.h,
              width: 10.h,
              child: Padding(
                padding: EdgeInsets.all(3.sp),
                child: Center(
                    child: organization.pic == null
                        ? Image.asset(
                            organization.name.isEmpty
                                ? 'assets/icons/no_organization.png'
                                : 'assets/icons/organization_building.png',
                            scale: 8)
                        : Image.network(organization.pic!)),
              )),
        ));
  }
}
