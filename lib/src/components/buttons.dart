import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'my_text.dart';

class BizneBackButton extends StatelessWidget {
  final void Function()? onPressed;
  const BizneBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppThemes().primary,
        ));
  }
}

class BizneOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final double heightFactor;
  final double? textSize;
  const BizneOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.textSize,
      this.heightFactor = 0.06});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height * heightFactor,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppThemes().primary, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: AppThemes().borderRadius)),
          onPressed: onPressed,
          child: MyText(
            text: title,
            fontSize: textSize == null ? 16.sp : textSize!,
            type: FontType.bold,
            color: AppThemes().primary,
          )),
    );
  }
}

class BizneElevatedButton extends StatelessWidget {
  final bool secondary;
  final void Function()? onPressed;
  final String title;
  final double heightFactor;
  final double widthFactor;
  final double? textSize;
  final Color? color;
  final bool autoWidth;
  final bool padding;
  const BizneElevatedButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.textSize,
      this.heightFactor = 0.05,
      this.widthFactor = 1,
      this.autoWidth = false,
      this.color,
      this.padding = true,
      this.secondary = false});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
        width: autoWidth ? null : width * widthFactor,
        height: height * heightFactor,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: padding ? null : EdgeInsets.zero,
                backgroundColor: secondary
                    ? AppThemes().white
                    : color ?? AppThemes().primary,
                shape: RoundedRectangleBorder(
                    borderRadius: AppThemes().borderRadius)),
            onPressed: onPressed,
            child: MyText(
              align: TextAlign.center,
              text: title,
              color:
                  secondary ? color ?? AppThemes().primary : AppThemes().white,
              fontSize: textSize == null ? 16.sp : textSize!,
              type: FontType.bold,
            )));
  }
}

class BizneTextButton extends StatelessWidget {
  final bool secondary;
  final void Function()? onPressed;
  final double heightFactor;
  final double widthFactor;
  final double? textSize;
  final Color? color;
  final bool autoWidth;
  final bool padding;
  final String title;

  const BizneTextButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.textSize,
      this.heightFactor = 0.05,
      this.widthFactor = 1,
      this.autoWidth = false,
      this.color,
      this.padding = true,
      this.secondary = false});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
        width: autoWidth ? null : width * widthFactor,
        height: height * heightFactor,
        child: TextButton(
            onPressed: onPressed,
            child: MyText(
              text: title,
              color: AppThemes().primary,
              fontSize: textSize == null ? 16.sp : textSize!,
              type: FontType.bold,
              decoration: TextDecoration.underline,
            )));
  }
}

class BizneElevatedChildButton extends StatelessWidget {
  final bool secondary;
  final void Function()? onPressed;
  final double heightFactor;
  final double widthFactor;
  final double? textSize;
  final Color? color;
  final bool autoWidth;
  final bool padding;
  final Widget child;

  const BizneElevatedChildButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.textSize,
      this.heightFactor = 0.05,
      this.widthFactor = 1,
      this.autoWidth = false,
      this.color,
      this.padding = true,
      this.secondary = false});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
        width: autoWidth ? null : width * widthFactor,
        height: height * heightFactor,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: padding ? null : EdgeInsets.zero,
                backgroundColor: secondary
                    ? AppThemes().white
                    : color ?? AppThemes().primary,
                shape: RoundedRectangleBorder(
                    borderRadius: AppThemes().borderRadius)),
            onPressed: onPressed,
            child: child));
  }
}

class BizneSupportButton extends StatelessWidget {
  final bool secondary;
  const BizneSupportButton({super.key, this.secondary = true});

  @override
  Widget build(BuildContext context) {
    return BizneElevatedChildButton(
        secondary: secondary,
        onPressed: () async {
          await Utils.contactSupport();
        },
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(0.8.h),
                  child: secondary
                      ? Image.asset('assets/icons/support_chat.png')
                      : Image.asset('assets/icons/support_chat_white.png'),
                )),
            Expanded(
                flex: 5,
                child: MyText(
                  type: FontType.semibold,
                  fontSize: 12.sp,
                  color: secondary ? AppThemes().primary : AppThemes().white,
                  text: AppLocalizations.of(context)!.needHelp,
                ))
          ],
        ));
  }
}

class BizneSupportMyBizneButton extends StatelessWidget {
  const BizneSupportMyBizneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BizneElevatedChildButton(
        onPressed: () async {
          await Utils.contactSupport();
        },
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(0.8.h),
                  child: Image.asset('assets/icons/support_chat_white.png'),
                )),
            Expanded(
                flex: 5,
                child: MyText(
                  type: FontType.semibold,
                  fontSize: 12.sp,
                  color: AppThemes().white,
                  text: AppLocalizations.of(context)!.needHelp,
                ))
          ],
        ));
  }
}
