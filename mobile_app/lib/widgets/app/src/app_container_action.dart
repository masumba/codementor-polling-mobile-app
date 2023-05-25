import 'package:flutter/widgets.dart';

class AppContainerAction {
  final String reference;
  final String title;
  final Widget? icon;
  final List<AppContainerAction> subItems;
  final void Function() onClick;

  AppContainerAction(
      {required this.reference,
      required this.title,
      this.icon,
      this.subItems = const [],
      required this.onClick});
}
