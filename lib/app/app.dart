import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:foodapp/app/shared_preferences.dart';
import 'package:foodapp/core/resources/routes_manager.dart';
import 'package:foodapp/core/resources/theme_manager.dart';
import 'package:foodapp/main.dart';
import 'package:foodapp/moduls/authentication/screens/forgot_password/change_password/view/change_password_view.dart';
import 'package:foodapp/moduls/authentication/screens/forgot_password/forgot_password/view/forgot_password_view.dart';
import 'package:foodapp/moduls/authentication/screens/login/view/login_view.dart';
import 'package:foodapp/moduls/authentication/screens/signup/view/otp/view/otp_signup_view.dart';
import 'package:foodapp/moduls/authentication/screens/signup/view/signup_view/signup_view.dart';
import 'package:foodapp/moduls/authentication/screens/success/success_view.dart';
import 'package:foodapp/moduls/authentication/screens/welcome/view/welcome_view.dart';
import 'package:foodapp/moduls/main/screens/card/view/card_view.dart';
import 'package:foodapp/moduls/main/screens/home/view/home_view.dart';
import 'package:foodapp/moduls/main/screens/home/view_model/home_viewmodel.dart';
import 'package:foodapp/moduls/main/screens/location/view/location_view.dart';
import 'package:foodapp/moduls/main/screens/main/view/main_view.dart';
import 'package:foodapp/moduls/main/screens/more/view/more_view.dart';
import 'package:foodapp/moduls/main/screens/more_screens/about/about_view.dart';
import 'package:foodapp/moduls/main/screens/order/view/order_view.dart';
import 'package:foodapp/moduls/main/screens/order/view/success_order.dart';
import 'package:foodapp/moduls/main/screens/order_tracker/view/order_page.dart';
import 'package:foodapp/moduls/main/screens/profil/view/profil_view.dart';
import 'package:foodapp/moduls/onboarding/view/onboarding_view.dart';
import 'package:foodapp/moduls/splash_screen/splash_screen.dart';
import 'package:get/route_manager.dart';

class MyApp extends StatefulWidget {
  MyApp._interal();
  static final _inestance = MyApp._interal();
  factory MyApp() => _inestance;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(360, 690),
        splitScreenMode: true,
        builder: ((context, child) => GetMaterialApp(
              onGenerateRoute: RouteManager.getRoute,
              localizationsDelegates: const [
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale("ar", "AE")],
              locale: const Locale('ar', 'AE'),
              theme: getAppThemeData(),
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            )));
  }
}
