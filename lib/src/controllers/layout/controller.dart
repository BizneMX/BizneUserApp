import 'dart:io';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/acquire_bz_coins/controller.dart';
import 'package:bizne_flutter_app/src/controllers/acquire_bz_coins/view.dart';
import 'package:bizne_flutter_app/src/controllers/add_payment_method/controller.dart';
import 'package:bizne_flutter_app/src/controllers/add_payment_method/view.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/view.dart';
import 'package:bizne_flutter_app/src/controllers/app/controller.dart';
import 'package:bizne_flutter_app/src/controllers/app/view.dart';
import 'package:bizne_flutter_app/src/controllers/chage_password/controller.dart';
import 'package:bizne_flutter_app/src/controllers/chage_password/view.dart';
import 'package:bizne_flutter_app/src/controllers/change_location/controller.dart';
import 'package:bizne_flutter_app/src/controllers/congratulations_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/congratulations_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/consume_your_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/change_location/view.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/controller.dart';
import 'package:bizne_flutter_app/src/controllers/edit_phone/view.dart';
import 'package:bizne_flutter_app/src/controllers/edit_profile/controller.dart';
import 'package:bizne_flutter_app/src/controllers/edit_profile/view.dart';
import 'package:bizne_flutter_app/src/controllers/error/controller.dart';
import 'package:bizne_flutter_app/src/controllers/error/view.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/controller.dart';
import 'package:bizne_flutter_app/src/controllers/generate_report/view.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/history_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/view.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/controller.dart';
import 'package:bizne_flutter_app/src/controllers/my_reserves/controller.dart';
import 'package:bizne_flutter_app/src/controllers/my_reserves/view.dart';
import 'package:bizne_flutter_app/src/controllers/notifications/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/pay_with_qr/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_with_qr/view.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/view.dart';
import 'package:bizne_flutter_app/src/controllers/consume_history/view.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_cashback/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_cashback/view.dart';
import 'package:bizne_flutter_app/src/controllers/profile/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile/view.dart';
import 'package:bizne_flutter_app/src/controllers/home/view.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/view.dart';
import 'package:bizne_flutter_app/src/controllers/notifications/view.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/view.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/controller.dart';
import 'package:bizne_flutter_app/src/controllers/rate_service/view.dart';
import 'package:bizne_flutter_app/src/controllers/restaurant_details/controller.dart';
import 'package:bizne_flutter_app/src/controllers/restaurant_details/view.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/controller.dart';
import 'package:bizne_flutter_app/src/controllers/schedule_food/view.dart';
import 'package:bizne_flutter_app/src/controllers/service_details/controller.dart';
import 'package:bizne_flutter_app/src/controllers/service_details/view.dart';
import 'package:bizne_flutter_app/src/controllers/set_organization/controller.dart';
import 'package:bizne_flutter_app/src/controllers/set_organization/view.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/controller.dart';
import 'package:bizne_flutter_app/src/controllers/terms_and_conditions/controller.dart';
import 'package:bizne_flutter_app/src/controllers/terms_and_conditions/view.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/view.dart';
import 'package:bizne_flutter_app/src/controllers/tip/controller.dart';
import 'package:bizne_flutter_app/src/controllers/tip/view.dart';
import 'package:bizne_flutter_app/src/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LayoutController extends GetxController {
  var currentIndex = 0.obs;
  var showTutorial = false.obs;

  List<LayoutRoute> primaryRoutes = [];

  List<LayoutRoute> secondaryRoutes = [];
  List<LayoutRoute> routes() => primaryRoutes + secondaryRoutes;
  var stack = List<CurrentRouteLayout>.empty().obs;

  final GlobalKey homeScreenKey = GlobalKey();
  final GlobalKey mapKey = GlobalKey();
  final GlobalKey firstCardKey = GlobalKey();
  final GlobalKey myBizneKey = GlobalKey();
  final GlobalKey profileKey = GlobalKey();

  late bool connection;

  @override
  void onInit() {
    super.onInit();

    connection = ConnectivityService.service.isOnline;

    if (connection) {
      checkNoConnection();
    } else {
      checkConnection();
    }

    // if (connection) checkTutorial();

    final context = Get.context!;

    primaryRoutes = [
      LayoutRoute<HomeController>(
          primary: true,
          route: home,
          index: 0,
          widget: (dynamic param) => HomePage(
              homeScreen: homeScreenKey, map: mapKey, firstCard: firstCardKey)),
      LayoutRoute<MyByzneController>(
          primary: true,
          route: myBizne,
          index: 1,
          widget: (dynamic param) => const MyByznePage()),
      LayoutRoute<AppController>(
          primary: true,
          titleElevation: true,
          route: app,
          navigationBar: false,
          buttonBack: true,
          index: 2,
          widget: (dynamic params) => const AppPage()),
      LayoutRoute<NotificationsController>(
          title: AppLocalizations.of(context)!.notifications,
          titleElevation: true,
          primary: true,
          route: notifications,
          index: 3,
          widget: (dynamic param) => const NotificationsPage()),
      LayoutRoute<ProfileHomeController>(
          primary: true,
          route: profileHome,
          index: 4,
          widget: (dynamic param) => const ProfileHomePage()),
      LayoutRoute<ProfileController>(
          route: profile,
          index: 4,
          buttonBack: true,
          widget: (dynamic params) => ProfilePage(
                params: params,
              )),
    ];

    var homeRoutes = [
      LayoutRoute<PayFoodController>(
          title: AppLocalizations.of(context)!.payYourMenu,
          titleElevation: true,
          navigationBar: false,
          route: payFood,
          index: 0,
          widget: (params) => PayFoodPage(params: params)),
      LayoutRoute<ConsumeYourFoodController>(
          title: AppLocalizations.of(context)!.payYourMenu,
          titleElevation: true,
          navigationBar: false,
          route: consumeYourFood,
          index: 0,
          widget: (dynamic params) => ConsumeYourFoodPage(
                params: params,
              )),
      LayoutRoute<CongratulationsFoodController>(
          navigationBar: false,
          route: congratulationsFood,
          popNavigate: false,
          index: 0,
          widget: (dynamic params) => CongratulationsFoodPage(
                params: params,
              )),
      LayoutRoute<RateServiceController>(
          navigationBar: false,
          index: 0,
          popNavigate: false,
          route: rateService,
          widget: (dynamic params) => RateServicePage(
                params: params,
              )),
      LayoutRoute<ChangeLocationController>(
        route: changeLocation,
        index: 0,
        widget: (dynamic params) => const ChangeLocationPage(),
        navigationBar: false,
        buttonBack: true,
        title: AppLocalizations.of(context)!.changeLocation,
      ),
      LayoutRoute<ServiceDetailsController>(
          route: serviceDetails,
          index: 0,
          widget: (dynamic params) => ServiceDetailsPage(
                params: params,
              ),
          buttonBack: false,
          navigationBar: true),
      LayoutRoute<RestaurantDetailsController>(
          route: restaurantDetails,
          index: 0,
          widget: (dynamic params) => RestaurantDetailsPage(params: params),
          buttonBack: false,
          navigationBar: true),
      LayoutRoute<ScheduleFoodController>(
          title: AppLocalizations.of(context)!.bookings,
          buttonBack: true,
          route: scheduleFoodRules,
          index: 0,
          navigationBar: false,
          widget: (dynamic params) => ScheduleFoodRulesPage(
                params: params,
              )),
      LayoutRoute<ScheduleFoodController>(
          title: AppLocalizations.of(context)!.bookingStepOne,
          buttonBack: true,
          route: scheduleFoodStepOne,
          index: 0,
          navigationBar: false,
          widget: (dynamic params) => ScheduleFoodStepOnePage(
                params: params,
              )),
      LayoutRoute<ScheduleFoodController>(
          title: AppLocalizations.of(context)!.bookingStepTwo,
          buttonBack: true,
          route: scheduleFoodStepTwo,
          index: 0,
          navigationBar: false,
          widget: (dynamic params) => ScheduleFoodStepTwoPage(
                params: params,
              )),
      LayoutRoute<ScheduleFoodController>(
          route: scheduleFoodCongratulations,
          index: 0,
          navigationBar: false,
          popNavigate: false,
          widget: (dynamic params) => ScheduleFoodCongratulationsPage(
                params: params,
              ))
    ];

    var myBizneRoutes = [
      LayoutRoute<ConsumeYourFoodController>(
          title: AppLocalizations.of(context)!.consumptionHistory,
          titleElevation: true,
          navigationBar: false,
          buttonBack: true,
          route: consumeHistory,
          index: 1,
          widget: (dynamic param) => const ConsumeHistoryPage()),
      LayoutRoute<AcquireBzCoinsController>(
        route: acquireBzCoins,
        index: 1,
        widget: (dynamic param) => const AcquireBzCoinsPage(),
        buttonBack: true,
        navigationBar: false,
      ),
      LayoutRoute<SuccessPaymentController>(
          route: successPayment,
          index: 1,
          navigationBar: false,
          widget: (dynamic params) => SuccessPaymentPage(
                params: params,
              )),
      LayoutRoute<AmountToPayController>(
          route: amountToPay,
          buttonBack: true,
          navigationBar: false,
          index: 1,
          widget: (dynamic params) => AmountToPayPage(
                params: params,
              )),
      LayoutRoute<SetOrganizationController>(
          title: AppLocalizations.of(context)!.setOrganization,
          index: 1,
          route: setOrganizations,
          buttonBack: true,
          navigationBar: false,
          widget: (dynamic params) => SetOrganizationPage(
                params: params,
              )),
      LayoutRoute<PayWithQRController>(
          title: AppLocalizations.of(Get.context!)!.payWithQR,
          buttonBack: true,
          navigationBar: false,
          titleElevation: true,
          route: payWithQR,
          index: 1,
          widget: (dynamic params) => PayWithQRPage(
                params: params,
              ))
    ];

    var appRoutes = [
      LayoutRoute<ErrorController>(
          popNavigate: false,
          primary: false,
          route: error,
          index: 2,
          navigationBar: false,
          widget: (dynamic params) {
            return ErrorPage(
              params: params,
            );
          }),
      LayoutRoute<HowYouWantPayController>(
          route: howYouWantPay,
          buttonBack: true,
          index: 2,
          widget: (dynamic params) => HowYouWantPayPage(params: params),
          navigationBar: false),
      LayoutRoute<TipController>(
          route: tip,
          index: 2,
          buttonBack: true,
          navigationBar: false,
          widget: (dynamic params) => TipPage(
                params: params,
              )),
      LayoutRoute<PaymentWithCashBackController>(
          popNavigate: false,
          primary: true,
          route: paymentWithCashback,
          index: 2,
          widget: (dynamic param) => PaymentWithCashbackPage(params: param),
          navigationBar: false),
    ];

    var profileRoutes = [
      LayoutRoute<TermsAndConditionController>(
          route: termsAndConditions,
          index: 4,
          buttonBack: true,
          widget: (dynamic param) => TermsAndConditionsPage(
                params: param,
              )),
      LayoutRoute<EditPhoneController>(
          route: editPhone,
          index: 4,
          buttonBack: true,
          navigationBar: false,
          title: AppLocalizations.of(context)!.editPhone,
          widget: (dynamic param) => EditPhonePage(
                params: param,
              )),
      LayoutRoute<HistoryFoodController>(
          route: historyFood,
          index: 4,
          buttonBack: true,
          navigationBar: false,
          title: AppLocalizations.of(context)!.foodHistory,
          widget: (dynamic param) => const HistoryFoodPage()),
      LayoutRoute<GenerateReportController>(
          route: generateReport,
          index: 4,
          buttonBack: true,
          navigationBar: false,
          title: AppLocalizations.of(context)!.generateReport,
          widget: (dynamic params) => GenerateReportPage(
                params: params,
              )),
      LayoutRoute<ChangePasswordController>(
          route: changePassword,
          index: 4,
          buttonBack: true,
          navigationBar: false,
          title: AppLocalizations.of(context)!.changePassword,
          widget: (dynamic param) => const ChangePasswordPage()),
      LayoutRoute<EditProfileController>(
          route: editProfile,
          index: 4,
          buttonBack: true,
          navigationBar: false,
          title: AppLocalizations.of(context)!.editProfile,
          widget: (dynamic param) => EditProfilePage(
                params: param,
              )),
      LayoutRoute<PaymentMethodsController>(
          title: AppLocalizations.of(context)!.paymentMethods,
          titleElevation: true,
          route: paymentMethods,
          buttonBack: true,
          navigationBar: true,
          index: 4,
          widget: (dynamic param) => const PaymentMethodsPage()),
      LayoutRoute<AddPaymentMethodController>(
          title: AppLocalizations.of(context)!.addPaymentMethod,
          titleElevation: true,
          route: addPaymentMethod,
          buttonBack: true,
          navigationBar: false,
          index: 4,
          widget: (dynamic param) => const AddPaymentMethodPage()),
      LayoutRoute<MyReserveController>(
          route: myReserves,
          buttonBack: true,
          navigationBar: false,
          index: 4,
          widget: (dynamic param) => const MyReservesPage())
    ];

    secondaryRoutes = [
      ...myBizneRoutes,
      ...appRoutes,
      ...profileRoutes,
      ...homeRoutes,
    ];

    navigate(connection ? home : myBizne);
  }

  void checkConnection() {
    final connectionNotifier = ConnectivityService.service.connectivityStatus;
    connectionNotifier.addListener(() {
      if (ConnectivityService.service.isOnline) {
        connectionNotifier.removeListener(() {});
        Get.offAllNamed(splash);
      }
    });
  }

  void checkNoConnection() {
    final connectionNotifier = ConnectivityService.service.connectivityStatus;
    connectionNotifier.addListener(() {
      if (!ConnectivityService.service.isOnline) {
        connectionNotifier.removeListener(() {});
        connection = false;
        stack.clear();
        navigate(myBizne);
        checkConnection();
      }
    });
  }

  CurrentRouteLayout getRoute() {
    return stack.lastOrNull ??
        CurrentRouteLayout.getCurrentRoute(primaryRoutes.first);
  }

  void changeTab(int index) {
    if (!connection) return;
    currentIndex.value = index;

    for (var route in primaryRoutes) {
      if (route.index == index && route.primary) {
        if (stack.isNotEmpty) {
          stack.last.route.getController().clear();
        }
        stack.add(CurrentRouteLayout.getCurrentRoute(route));
      }
    }
  }

  void navigate(String routeName, {dynamic params}) {
    if (stack.isNotEmpty) {
      stack.last.route.getController().clear();
    }
    for (var route in routes()) {
      if (route.route == routeName) {
        currentIndex.value = route.index;
        stack.add(CurrentRouteLayout.getCurrentRoute(route, params: params));
      }
    }
  }

  void popNavigate() async {
    if (!stack.last.route.popNavigate) return;
    stack.last.route.getController().clear();
    if (stack.last.route.route == home) {
      var len = stack.length;
      for (var i = 0; i < len - 1; i++) {
        stack.removeLast();
      }
    }

    if (stack.length == 1) {
      await Get.dialog(
          BizneAppGoOutDialog(
            onOk: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // Cierra la aplicación en Android
              } else if (Platform.isIOS) {
                exit(0); // Cierra la aplicación en iOS
              }
            },
            onCancel: () => Get.back(),
          ),
          barrierDismissible: true);

      return;
    }

    stack.removeLast();
    currentIndex.value = stack.last.route.index;
  }

  void checkTutorial() async {
    if (connection) {
      final prefs = await SharedPreferences.getInstance();
      showTutorial.value = prefs.getBool('showTutorial') ?? true;
    }
  }

  void setTutorialFinish() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showTutorial', false);
    showTutorial.value = false;
  }
}

abstract class LayoutRouteController extends GetxController {
  final layoutController = Get.find<LayoutController>();

  AppLocalizations? getLocalizations() {
    return AppLocalizations.of(Get.context!);
  }

  void navigate(String routeName, {dynamic params}) {
    layoutController.navigate(routeName, params: params);
  }

  void popNavigate({void Function()? afterPop}) {
    layoutController.popNavigate();
    if (afterPop != null) {
      afterPop();
    }
  }

  bool connection() {
    return layoutController.connection;
  }

  void clear() {}
}

class CurrentRouteLayout {
  final LayoutRouteWidget widget;
  final LayoutRoute route;

  const CurrentRouteLayout({required this.route, required this.widget});

  static CurrentRouteLayout getCurrentRoute(LayoutRoute route,
          {dynamic params}) =>
      CurrentRouteLayout(route: route, widget: route.widget(params));
}

abstract class LayoutRouteWidget<T extends LayoutRouteController>
    extends GetWidget<T> {
  final dynamic params;
  const LayoutRouteWidget({super.key, this.params});
}

class LayoutRoute<T extends LayoutRouteController> {
  final bool primary;
  final bool buttonBack;
  final bool navigationBar;
  final String? title;
  final bool titleElevation;
  final String route;
  final int index;
  final bool popNavigate;
  final LayoutRouteWidget Function(dynamic) widget;

  LayoutRoute(
      {required this.route,
      required this.index,
      required this.widget,
      this.popNavigate = true,
      this.title,
      this.buttonBack = false,
      this.navigationBar = true,
      this.primary = false,
      this.titleElevation = false});

  T getController() => Get.find<T>();
}
