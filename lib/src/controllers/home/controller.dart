import 'dart:async';

import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/home/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/map/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_food/controller.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/models/marker.dart';
import 'package:bizne_flutter_app/src/models/pagination_data.dart';
import 'package:bizne_flutter_app/src/services/location.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends LayoutRouteController {
  final scrollDraggerController = ScrollDraggerController();
  final repo = HomeRepo();

  Rx<LatLng> userLocation = (const LatLng(0, 0)).obs;
  RxString address = ''.obs;
  var selectedService = true.obs;
  final searchController = TextEditingController();
  var cant = 10;
  var total = 0;
  var page = 0;
  var isLoading = false;
  var activeFilter = 1.obs;

  late MapController mapController;
  final List<MarkerInfo> pins = [];

  @override
  void onInit() {
    super.onInit();

    if (!connection()) return;

    scrollDraggerController.loadNextPage = getEstablishments;
    Get.put(scrollDraggerController);
    mapController = Get.find<MapController>();

    notificationToken();
    setMarkers();
    getUserLocation();
    if (userLocation.value.latitude != 0 || userLocation.value.longitude != 0) {
      getEstablishments(clear: true);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollDraggerController.dispose();
    super.dispose();
  }

  Future<void> notificationToken() async {
    final prefs = await SharedPreferences.getInstance();

    bool notificationPermission = prefs.getBool('notificationPermission')!;
    if (notificationPermission) {
      await repo.registerToken();
    }
  }

  void getUserLocation() {
    userLocation.value = LocationProvide.service.userLocation.value;
    // address.value = await LocationProvide.service.getAddressByLocation(
    //     userLocation.value.latitude, userLocation.value.longitude);
    // ever(LocationProvide.service.userLocation, (value) async {
    //   userLocation.value = value;
    //   print(userLocation.toString() +
    //       "userLocation"); // address.value = await LocationProvide.service.getAddressByLocation(
    //   getEstablishments(clear: true);
    //   // address.value = await LocationProvide.service.getAddressByLocation(
    //   //     userLocation.value.latitude, userLocation.value.longitude);
    // }, condition: true);
    LocationProvide.service.userLocation.addListener(() async {
      userLocation.value = LocationProvide.service.userLocation.value;
      getEstablishments(clear: true).whenComplete(() {
        mapController.goToUserLocation();
        Get.find<LayoutController>().checkTutorial();
      });
    });
  }

  void goToLocation(LatLng position) {
    mapController.goToLocation(position);
  }

  Future<void> transactionData(Establishment establishment) async {
    if (establishment.closed) {
      await Get.dialog(const EstablishmentClosedDialog());
      return;
    }

    EasyLoading.show();
    final response = await repo.transactionData(establishment.id);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }
    navigate(payFood,
        params: PayFoodParams(
            establishment: establishment,
            todayBzCoins: Utils.decodeInt(response.data['today_bzcoins'] == null
                ? '0'
                : response.data['today_bzcoins'].toString()),
            walletLimited:
                Utils.decodeInt(response.data['wallet_limited'].toString()) == 1
                    ? true
                    : false,
            menuPrice:
                Utils.decodeInt(response.data['menu_price'].toString())));
  }

  Future<void> getEstablishments({clear = false}) async {
    if (isLoading) return;

    if (!clear) {
      if (scrollDraggerController.establishments.length == total) return;
    }

    isLoading = true;

    if (clear) {
      page = 0;
      total = 0;
      scrollDraggerController.establishments.clear();
    }

    EasyLoading.show();
    final response = await repo.getEstablishments({
      'lat': userLocation.value.latitude,
      'lng': userLocation.value.longitude,
      'category': selectedService.value ? 2 : 1,
      'search': searchController.text,
      'count': cant
    }, clear ? 1 : page + 1, activeFilter.value);
    EasyLoading.dismiss(animation: true);

    isLoading = false;

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final paginationData = response.data as PaginationData<Establishment>;
    total = paginationData.total;
    page = paginationData.page;
    scrollDraggerController.establishments.addAll(paginationData.data);
    // setMarkers();
  }

  void setMarkers() async {
    final response = await repo.getEstablishmentPins();

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    pins.addAll(response.data as List<MarkerInfo>);
    filterPins();
  }

  void filterPins() => mapController.setMarkers(pins
      .where((element) => !(element.fonda ^ selectedService.value))
      .toList());

  void changeFilter(int index) async {
    String firebaseOption = "";
    if (index == 1) {
      firebaseOption = 'mas_cercanas';
    } else if (index == 2) {
      firebaseOption = 'favoritas';
    } else if (index == 3) {
      firebaseOption = 'abiertas';
    }
    await FirebaseAnalytics.instance.logEvent(
      name: 'user_app_map_${firebaseOption}',
      parameters: {
        'type': 'button',
        'name': firebaseOption
      }
    );

    if (activeFilter.value == index) {
      return;
    }

    activeFilter.value = index;
    getEstablishments(clear: true);
  }

  Future<void> setFavoriteByIndex(int index) async {
    final establishment = scrollDraggerController.establishments[index];
    await setFavorite(establishment);
    scrollDraggerController.establishments[index] = establishment;
  }

  Future<void> setFavorite(Establishment establishment) async {
    EasyLoading.show();
    final response =
        await repo.setFavorite(establishment.id, !establishment.favorite);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    establishment.favorite = !establishment.favorite;
  }

  void onTapEstablishment(Establishment item) {
    final establishmentPosition =
        LatLng(double.parse(item.lat), double.parse(item.lng));
    dragToBottom();
    goToLocation(establishmentPosition);
    mapController.showInfoWindow(item.id);
  }

  void dragToBottom() {
    scrollDraggerController.toBottom();
  }

  @override
  void clear() {
    scrollDraggerController.scroll.value = scrollDraggerController.middle;
  }

  void updateAddress(String value) => address.value = value;
}

class ScrollDraggerController extends GetxController {
  late Function() loadNextPage;
  final middle = 0.5;
  final bottomMiddle = 0.2;
  final bottom = 0.05;
  final top = 1.0;
  RxDouble scroll = 0.5.obs;
  RxList<Establishment> establishments = <Establishment>[].obs;

  final scrollDraggableController = DraggableScrollableController();
  ScrollController? scrollController;

  static const animation = 500;

  void pagination() {
    if (scrollController!.position.pixels + 500 >=
        scrollController!.position.maxScrollExtent) {
      loadNextPage();
    }
  }

  void toBottom() {
    if (scroll.value == bottom) return;
    scrollDraggableController
        .animateTo(
          bottom,
          duration: const Duration(milliseconds: animation),
          curve: Curves.easeInOut,
        )
        .then((value) => scroll.value = bottom);
  }

  void toMiddle() {
    scrollDraggableController
        .animateTo(
          middle,
          duration: const Duration(milliseconds: animation),
          curve: Curves.easeInOut,
        )
        .then((value) => scroll.value = middle);
  }

  void dragUpdate(double dy) {
    if (dy > 5) {
      if (scrollDraggableController.size > middle) {
        scrollDraggableController
            .animateTo(
              middle,
              duration: const Duration(milliseconds: animation),
              curve: Curves.easeInOut,
            )
            .then((value) => scroll.value = middle);
        return;
      }
      if (scrollDraggableController.size > bottom) {
        scrollDraggableController
            .animateTo(
              bottom,
              duration: const Duration(milliseconds: animation),
              curve: Curves.easeInOut,
            )
            .then((value) => scroll.value = bottom);
        return;
      }
    }

    if (dy < -5) {
      if (scrollDraggableController.size >= middle) {
        scrollDraggableController
            .animateTo(
              top,
              duration: const Duration(milliseconds: animation),
              curve: Curves.easeInOut,
            )
            .then((value) => scroll.value = top);
        return;
      }
      if (scrollDraggableController.size >= bottom) {
        scrollDraggableController
            .animateTo(
              middle,
              duration: const Duration(milliseconds: animation),
              curve: Curves.easeInOut,
            )
            .then((value) => scroll.value = middle);
        return;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollDraggableController.addListener(() {
      scroll.value = scrollDraggableController.size;
    });
    scroll.value = middle;
  }

  void scrollControllerSubscribe(ScrollController controller) {
    if (scrollController != null) scrollController!.removeListener(pagination);
    scrollController = controller;
    scrollController!.addListener(pagination);
  }

  @override
  void dispose() {
    if (scrollController != null) scrollController!.removeListener(pagination);

    super.dispose();
  }
}
