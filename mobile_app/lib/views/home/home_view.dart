import 'package:flutter/material.dart';
import 'package:mobile_app/views/home/home_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Home',
        centerTitle: true,
        menuActions: model.menuActions(),
        containerBody: Placeholder(),
      ),
    );
  }
}
