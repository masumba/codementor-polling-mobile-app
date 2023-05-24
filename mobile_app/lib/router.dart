import 'package:flutter/material.dart';
import 'package:mobile_app/constants/route_names.dart';
import 'package:mobile_app/views/authentication/login/login_view.dart';

/// This function is triggered every time when calling Navigator.pushNamed.
/// It returns a Route depending on the routeName passed in the settings.
Route<dynamic> generateRoute(RouteSettings settings) {
  // Debug print to know the router was accessed
  debugPrint('Router Accessed');

  /// Switching on the routeName from settings
  switch (settings.name) {
    // If the routeName is loginViewRoute (the name of the route to the LoginView)
    case AppRoute.loginViewRoute:
      // Return a PageRoute with LoginView
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const LoginView(),
      );
    // For all other route names
    default:
      // Return a PageRoute with a Scaffold showing an error message
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

/// This is a helper function that returns a MaterialPageRoute
/// It takes a routeName and a viewToShow (the widget to be displayed)
PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name:
            routeName, // Assigning routeName to the settings of the MaterialPageRoute
      ),
      builder: (_) => viewToShow!); // The builder returns the widget to display
}
