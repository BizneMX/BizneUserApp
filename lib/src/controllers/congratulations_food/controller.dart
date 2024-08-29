import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/controller.dart';
import 'package:get/get.dart';

class CongratulationsFoodController extends LayoutRouteController {
  void close(CongratulationsFoodParams params) async {
    await Get.dialog(BizneAreYouSureCloseThisScreen(
      onOk: () {
        Get.back();
        navigate(rateService,
            params: RateServiceParams(
                establishment: params.establishment, visit: params.data));
      },
    ));
  }

  String getName() {
    final profileController = Get.find<ProfileHomeController>();

    return '${profileController.user[0].name} ${profileController.user[0].lastName}';
  }

  Future<void> contactBusiness(String phoneNumber) async {
    await Utils.contactWhatsApp(phoneNumber);
  }
}

class CongratulationsFoodParams extends ConsumeYourFoodParams {
  final int data;
  const CongratulationsFoodParams(
      {required this.data,
      required super.establishment,
      required super.amount,
      required super.diff});
}
