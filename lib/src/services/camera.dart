import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

///
/// Personalized service to get resources from the gallery or camera,
/// these resources can be anything from images or videos, to files
///
class CameraService extends GetxService {
  static CameraService get service => Get.find();
  Future<CameraService> init() async => this;

  ///
  /// Obtain the selected image object from the camera
  ///
  Future<XFile?> openImageFromCamera(int? imageQuality) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      return await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: imageQuality,
          requestFullMetadata: false);
    } else {
      Get.snackbar('Error', 'Permission for the camera has not been granted',
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  ///
  /// Get the selected image object from the gallery or library images
  ///
  Future<XFile?> openImageFromGallery(int? imageQuality) async {
    return await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        requestFullMetadata: false);
  }
}
