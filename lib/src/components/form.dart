import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'text_filed.dart';

class FormController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, GlobalKey<BizneTextFormFieldState>> formKeys = {};

  void addController(String fieldName, TextEditingController? controller) {
    controllers[fieldName] = controller ?? TextEditingController();
    formKeys[fieldName] = GlobalKey<BizneTextFormFieldState>();
  }

  void removeController(String fieldName) {
    controllers[fieldName]!.dispose();
    controllers.remove(fieldName);
    formKeys.remove(fieldName);
  }

  void clear() {
    controllers.forEach((key, value) {
      value.clear();
    });
  }

  bool validateAndSave() {
    bool isValid = true;
    formKeys.forEach((key, formKey) {
      if (formKey.currentState!.validate()) {
        controllers[key]!.text = controllers[key]!.text.trim();
      } else {
        isValid = false;
      }
    });
    return isValid;
  }

  Map<String, String> getValues() {
    final Map<String, String> values = {};
    controllers.forEach((key, controller) {
      values[key] = controller.text;
    });
    return values;
  }

  void setValues(Map<String, String?> values) {
    controllers.forEach((key, controller) {
      controller.text = values[key] ?? '';
    });
  }

  @override
  void onClose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.onClose();
  }
}
