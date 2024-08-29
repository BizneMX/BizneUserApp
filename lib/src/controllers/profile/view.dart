import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/profiler_avatar.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile/controller.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/services/camera.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends LayoutRouteWidget<ProfileController> {
  const ProfilePage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final user = params as User;
    controller.photoUrl.value = user.pic;

    Widget getButton(String title, Function() onPressed) {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: BizneElevatedButton(
              onPressed: onPressed,
              color: title == AppLocalizations.of(context)!.deleteAccount
                  ? AppThemes().negative
                  : null,
              textSize: 14.sp,
              title: title,
              secondary: true,
              heightFactor: 0.04));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 3.h,
      ),
      ProfileImage(
        user: user,
      ),
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
          AppLocalizations.of(context)!.editProfile,
          () => controller.navigate(editProfile, params: user)
        ),
        (
          AppLocalizations.of(context)!.editPhone,
          () => controller.navigate(editPhone, params: user)
        ),
        (
          AppLocalizations.of(context)!.setOrganization,
          () => controller.navigate(setOrganizations)
        ),
        (
          AppLocalizations.of(context)!.changePassword,
          () => controller.navigate(changePassword)
        ),
        (
          AppLocalizations.of(context)!.paymentMethods,
          () => controller.navigate(paymentMethods)
        ),
        (
          AppLocalizations.of(context)!.deleteAccount,
          () => controller.deleteAccount(user)
        )
      ].map((e) => getButton(e.$1, e.$2))
    ]);
  }
}

class ProfileImage extends GetWidget<ProfileController> {
  final User user;
  const ProfileImage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final String? imageLocation = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                    title: MyText(
                        text: AppLocalizations.of(context)!
                            .selectOrTakeAProfilePhoto,
                        align: TextAlign.center,
                        fontSize: 18,
                        color: AppThemes().primary,
                        type: FontType.bold),
                    titlePadding: const EdgeInsets.all(5),
                    backgroundColor: AppThemes().background,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    alignment: Alignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () => Get.back(result: 'camera'),
                                icon: Icon(Icons.camera_alt_outlined,
                                    color: AppThemes().primary)),
                            IconButton(
                                onPressed: () => Get.back(result: 'gallery'),
                                icon: Icon(Icons.photo_library_outlined,
                                    color: AppThemes().primary))
                          ])
                    ]);
              });
          final XFile? image;
          if (imageLocation == null) return;
          if (imageLocation == 'camera') {
            image = await CameraService.service.openImageFromCamera(30);
          } else {
            image = await CameraService.service.openImageFromGallery(30);
          }
          if (image != null) {
            CroppedFile? croppedFile = await ImageCropper()
                .cropImage(sourcePath: image.path, uiSettings: [
              AndroidUiSettings(
                  toolbarColor: AppThemes().primary,
                  toolbarWidgetColor: AppThemes().white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              IOSUiSettings(),
            ]);

            if (croppedFile != null) {
              controller.updateProfilePhoto(croppedFile, user);
            }
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: AppThemes().background,
                borderRadius: BorderRadius.circular(50.sp)),
            child: Stack(children: [
              Obx(() => ProfileAvatar(
                  imageUrl: controller.photoUrl.value,
                  placeholderImage: 'assets/images/default_profile.png',
                  size: 8.h)),
              Positioned(
                  bottom: 5.sp,
                  right: 5.sp,
                  child: Container(
                      height: 20.sp,
                      width: 20.sp,
                      decoration: BoxDecoration(
                          color: AppThemes().primary,
                          borderRadius: BorderRadius.circular(50.sp)),
                      child: Icon(Icons.edit,
                          color: AppThemes().white, size: 15.sp)))
            ])));
  }
}
