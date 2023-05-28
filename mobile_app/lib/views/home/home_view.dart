import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/views/home/home_view_model.dart';
import 'package:mobile_app/views/home/tabs/image_post_viewer_tab.dart';
import 'package:mobile_app/views/home/tabs/my_image_post_tab.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _screens = [
    ImagePostViewerTab(),
    MyImagePostTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Home',
        centerTitle: true,
        menuActions: model.menuActions(),
        containerBody: _screens[model.selectedTabIndexHomeView],
        bottomNavBar: BottomNavigationBar(
          currentIndex: model.selectedTabIndexHomeView,
          onTap: (indexValue) {
            model.updateIndex(indexValue);
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: AppColor.primaryColorDark.toColor(),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Polling Images",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload),
              label: "My Uploads",
            ),
          ],
        ),
        fab: FloatingActionButton(
          backgroundColor: AppColor.primaryColorDark.toColor(),
          onPressed: () async {
            model.navigateToImagePostView();
          },
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
