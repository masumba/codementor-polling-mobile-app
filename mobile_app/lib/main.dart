import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/constants/app_string.dart';
import 'package:mobile_app/constants/theme.dart';
import 'package:mobile_app/router.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/views/app_base_view_model.dart';
import 'package:mobile_app/views/start_up/start_up_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  /*runApp(const MyApp());*/
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
        (_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // For Android
        statusBarIconBrightness: Brightness.dark,
        // For iOS.
        statusBarBrightness: Brightness.light,
      ));
      return runApp(const MyApp());
    },
  )
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.title,
      color: Colors.white,
      theme: AppTheme.defaultTheme(),
      home: ChangeNotifierProvider(
        create: (context) => AppBaseViewModel(),
        child: const StartUpView(),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
    );
  }
}
