import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/views/start_up/start_up_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:mobile_app/widgets/loading_progress.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => AppContainer(
        showAppBar: false,
        overrideSingleScrollRoot: true,
        containerBody: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    AppImage.logo,
                    width: ScreenUtil.screenWidth(context) * 0.3,
                    height: ScreenUtil.screenHeight(context) * 0.4,
                  ),
                ),
              ),
            ),
            model.showLoader
                ? const Expanded(
                    flex: 2,
                    child: LoadingProgress(),
                  )
                : Expanded(
                    flex: 0,
                    child: Container(
                      height: 0,
                    ),
                  ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  model.appVersionNumber,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
