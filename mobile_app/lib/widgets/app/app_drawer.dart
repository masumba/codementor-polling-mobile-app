import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/constants/app_string.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/services/package_info_service.dart';
import 'package:mobile_app/widgets/app/src/app_container_action.dart';

class AppDrawer extends StatelessWidget {
  final List<AppContainerAction> drawerOptions;
  AppDrawer({this.drawerOptions = const [], Key? key}) : super(key: key);
  final NavigationService _navigationService = locator<NavigationService>();
  final PackageInfoService _packageInfoService = locator<PackageInfoService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColor.neutralColor.toColor(),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: drawerOptions.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return DrawerHeader(
                child: _profileWidget(),
              );
            }
            if (drawerOptions[index - 1].subItems.isEmpty) {
              return Column(
                children: [
                  ListTile(
                    leading: drawerOptions[index - 1].icon ??
                        const Icon(
                          FeatherIcons.share2,
                          color: Colors.black87,
                        ),
                    title: Text(
                      drawerOptions[index - 1].title,
                    ),
                    onTap: () {
                      _navigationService.pop();
                      drawerOptions[index - 1].onClick();
                    },
                  ),
                  const Divider(),
                ],
              );
            }
            return ExpansionTile(
              title: Text(
                drawerOptions[index - 1].title,
              ),
              leading: drawerOptions[index - 1].icon ??
                  const Icon(
                    FeatherIcons.share2,
                    color: Colors.black87,
                  ),
              childrenPadding: const EdgeInsets.only(left: 10),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: drawerOptions[index - 1].subItems.length,
                  itemBuilder: (context, childIndex) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            drawerOptions[index - 1].subItems[childIndex].title,
                          ),
                          onTap: () {
                            _navigationService.pop();
                            drawerOptions[index - 1]
                                .subItems[childIndex]
                                .onClick();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _profileWidget() {
    String version = 'Version: ${_packageInfoService.appVersion}';
    return InkWell(
      onTap: () {
        //TODo go to account screen
        //actionToAccount(x, member);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5 * 3,
        ),
        child: ListTile(
          leading: Image.asset(AppImage.logo),
          title: const Text(
            AppString.title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(
              version,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
