import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String placeholderImage;
  final double size;

  const ProfileAvatar({
    required this.imageUrl,
    required this.placeholderImage,
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: size,
        backgroundColor: AppThemes().background,
        child: _buildAvatarImage());
  }

  Widget _buildAvatarImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholderImage(placeholderImage);
    } else {
      return FutureBuilder(
        future: _loadNetworkImage(imageUrl!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return _buildPlaceholderImage(placeholderImage);
            } else {
              return CircleAvatar(
                radius: size,
                backgroundImage: NetworkImage(imageUrl!),
              );
            }
          } else {
            return _buildPlaceholderImage(placeholderImage);
          }
        },
      );
    }
  }

  Future<ImageStream> _loadNetworkImage(String url) async {
    try {
      final image = NetworkImage(url).resolve(ImageConfiguration.empty);
      return image;
    } catch (e) {
      throw Exception('Connection error');
    }
  }

  Widget _buildPlaceholderImage(String placeholder) {
    return CircleAvatar(
        radius: size,
        backgroundColor: AppThemes().background,
        backgroundImage: AssetImage(placeholder));
  }
}

class NameAndUserState extends StatelessWidget {
  final String name;
  final bool verified;
  const NameAndUserState(
      {super.key, required this.name, required this.verified});

  @override
  Widget build(BuildContext context) {
    final userState = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verified
            ? Icon(
                Icons.check_circle,
                color: AppThemes().green,
              )
            : Icon(
                Icons.cancel,
                color: AppThemes().negative,
              ),
        SizedBox(
          width: 2.w,
        ),
        verified
            ? MyText(
                fontSize: 14.sp,
                text: AppLocalizations.of(context)!.verifiedUser,
                color: AppThemes().green,
              )
            : MyText(
                fontSize: 14.sp,
                text: AppLocalizations.of(context)!.notVerifiedUser,
                color: AppThemes().negative,
              )
      ],
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      MyText(
        text: name,
        align: TextAlign.center,
        color: AppThemes().primary,
        fontSize: 20.sp,
        type: FontType.bold,
      ),
      SizedBox(
        height: 1.h,
      ),
      userState
    ]);
  }
}
