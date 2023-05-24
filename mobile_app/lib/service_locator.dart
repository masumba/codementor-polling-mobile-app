import 'dart:developer' as developer;
import 'package:get_it/get_it.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/services/package_info_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';

final GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  developer.log("Setting Up Locator Service.");

  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PackageInfoService());
  locator.registerLazySingleton(() => DialogService());

  locator.registerFactory(() => AppBaseViewModel());
}
