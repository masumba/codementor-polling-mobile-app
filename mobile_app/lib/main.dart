import 'package:firebase_core/firebase_core.dart';
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

/// Main function, the entry point of the app
void main() async {
  // Ensure binding exist before running the app
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Set up service locator
  await setUpLocator();

  // Set the preferred orientations and then run the app
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) {
      // Set system UI overlay style and then run the app
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // For Android
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        statusBarBrightness: Brightness.light,
      ));
      // Run the app
      return runApp(const MyApp());
    },
  );
}

/// MyApp widget is the root of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Return MaterialApp widget
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.title,
      color: Colors.white,
      theme: AppTheme.defaultTheme(),
      home: ChangeNotifierProvider(
        // Provide AppBaseViewModel to widgets that are descendants of this Provider.
        create: (context) => AppBaseViewModel(),
        child: const StartUpView(),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
    );
  }
}
