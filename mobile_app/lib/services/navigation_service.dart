import 'package:flutter/material.dart';

/// The NavigationService class
class NavigationService {
  /// Define a GlobalKey of type NavigatorState
  /// This will be used to access the NavigatorState without needing the BuildContext
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  /// Getter for the _navigationKey
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  /// Pops the top-most Route off the navigation stack
  void pop() {
    _navigationKey.currentState!.pop();
  }

  /// Navigates to the route with the given name
  /// Optionally, pass arguments to the route
  /// Returns a Future that completes to the result value when the pushed route is popped off the navigation stack
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  /// Navigates to the route with the given name and removes all previous routes
  /// Optionally, pass arguments to the route
  /// Returns a Future that completes to the result value when the pushed route is popped off the navigation stack
  Future<dynamic> navigateToWithNoBack(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }
}
