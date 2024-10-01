import 'package:bizne_flutter_app/src/controllers/acquire_bz_coins/controller.dart';
import 'package:bizne_flutter_app/src/controllers/add_payment_method/controller.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/app/controller.dart';
import 'package:bizne_flutter_app/src/controllers/chage_password/controller.dart';
import 'package:bizne_flutter_app/src/controllers/congratulations_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/change_location/controller.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/controller.dart';
import 'package:bizne_flutter_app/src/controllers/edit_profile/controller.dart';
import 'package:bizne_flutter_app/src/controllers/error/controller.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/controller.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/controller.dart';
import 'package:bizne_flutter_app/src/controllers/my_reserves/controller.dart';
import 'package:bizne_flutter_app/src/controllers/notifications/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_with_qr/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_cashback/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_discount/controller.dart';
import 'package:bizne_flutter_app/src/controllers/consume_history/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile/controller.dart';
import 'package:bizne_flutter_app/src/controllers/home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/map/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/controller.dart';
import 'package:bizne_flutter_app/src/controllers/restaurant_details/controller.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/service_details/controller.dart';
import 'package:bizne_flutter_app/src/controllers/set_organization/controller.dart';
import 'package:bizne_flutter_app/src/controllers/terms_and_conditions/controller.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/controller.dart';
import 'package:bizne_flutter_app/src/controllers/tip/controller.dart';
import 'package:get/get.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LayoutController>(LayoutController());

    //home
    Get.put<MapController>(MapController());
    Get.put<HomeController>(HomeController());
    Get.put<PayFoodController>(PayFoodController());
    Get.put<ConsumeYourFoodController>(ConsumeYourFoodController());
    Get.put<CongratulationsFoodController>(CongratulationsFoodController());
    Get.put<RateServiceController>(RateServiceController());
    Get.put<ChangeLocationController>(ChangeLocationController());
    Get.put<ServiceDetailsController>(ServiceDetailsController());
    Get.put<RestaurantDetailsController>(RestaurantDetailsController());
    Get.put<ScheduleFoodController>(ScheduleFoodController());

    //notifications
    Get.put<NotificationsController>(NotificationsController());

    //profile
    Get.put<ProfileHomeController>(ProfileHomeController());
    Get.put<ProfileController>(ProfileController());
    Get.put<TermsAndConditionController>(TermsAndConditionController());
    Get.put<EditPhoneController>(EditPhoneController());
    Get.put<HistoryFoodController>(HistoryFoodController());
    Get.put<GenerateReportController>(GenerateReportController());
    Get.put<ChangePasswordController>(ChangePasswordController());
    Get.put<EditProfileController>(EditProfileController());
    Get.put<PaymentMethodsController>(PaymentMethodsController());
    Get.put<AddPaymentMethodController>(AddPaymentMethodController());
    Get.put<MyReserveController>(MyReserveController());

    //my-bizne
    Get.put<MyByzneController>(MyByzneController());
    Get.put<ConsumeHistoryController>(ConsumeHistoryController());
    Get.put<AcquireBzCoinsController>(AcquireBzCoinsController());
    Get.put<AmountToPayController>(AmountToPayController());
    Get.put<SetOrganizationController>(SetOrganizationController());
    Get.put<PayWithQRController>(PayWithQRController());

    //app-controller
    Get.put<AppController>(AppController());

    //notification-controller
    Get.put<NotificationsController>(NotificationsController());
    Get.put<SuccessPaymentController>(SuccessPaymentController());

    //app
    Get.put<HowYouWantPayController>(HowYouWantPayController());
    Get.put<PaymentWithDiscountController>(PaymentWithDiscountController());
    Get.put<PaymentWithCashBackController>(PaymentWithCashBackController());
    Get.put<TipController>(TipController());
    Get.put<ErrorController>(ErrorController());
  }
}
