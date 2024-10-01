import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/routes/authentication_routes.dart';
import 'package:bizne_flutter_app/src/routes/home_routes.dart';
import 'package:bizne_flutter_app/src/routes/initial_routes.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BizneApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final _navigatorKey = GlobalKey<NavigatorState>();
  BizneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppThemes().background,
        child: SafeArea(
            child: Container(
                color: AppThemes().background,
                child: Sizer(builder: (context, orientation, deviceType) {
                  return GetMaterialApp(
                      navigatorObservers: <NavigatorObserver>[observer],
                      navigatorKey: _navigatorKey,
                      title: 'Bizne App',
                      theme: AppThemes().theme,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        // Locale('en', ''), // English, no country code
                        Locale('es', ''), // Spanish, no country code
                      ],
                      fallbackLocale: const Locale('es', 'MX'),
                      initialRoute: splash,
                      getPages: [
                        ...HomePages.pages,
                        ...AuthenticationPages.pages,
                        ...InitialPages.pages
                      ],
                      builder: EasyLoading.init());
                }))));
  }
}
