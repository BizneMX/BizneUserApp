import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';

class ScheduleFoodController extends LayoutRouteController {
  Future<void> contactBusiness(String phoneNumber) async {
    await Utils.contactWhatsApp(phoneNumber);
  }
}
