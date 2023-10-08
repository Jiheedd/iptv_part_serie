import 'package:flutter/material.dart';
import '../ui/series/view/series_home_view.dart';
import 'strings_manager.dart';

class Routes {
  static const String seriesRoute = "/splashChoice";
  static const String loginRoute = "/login";

  // static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";

  // static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
// static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (_) => SeriesHomeView(
              nameSlider: 'Serie',
            ));
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(child: Text(AppStrings.noRouteFound)),
      ),
    );
  }
}
