import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/constants/app_string.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/services/check_internet_service.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/utils/shared_style_util.dart';
import 'package:mobile_app/widgets/app/src/app_container_action.dart';
import 'package:mobile_app/widgets/cards/notice_card.dart';
import 'package:mobile_app/widgets/loading_progress.dart';

class AppContainer extends StatefulWidget {
  final String appBarTitle;
  final String? appBarSubTitle;
  final Widget containerBody;
  final Widget? fab;
  final Widget? bottomNavBar;
  final Widget? appDrawer;
  final PreferredSizeWidget? appBarBottom;
  final bool centerTitle;
  final bool overrideSingleScrollRoot;
  final bool showLogout;
  final bool pageLoading;
  final bool showAppBar;
  final bool useLogo;
  final bool useDropDown;
  final bool underDevelopment;
  final List<AppContainerAction>? menuActions;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? appBarActionButton;

  /// The color of the [Material] widget that underlies the entire Scaffold.
  ///
  /// The theme's [ThemeData.scaffoldBackgroundColor] by default.
  final Color? backgroundColor;

  const AppContainer({
    Key? key,
    required this.containerBody,
    this.appBarTitle = AppString.title,
    this.showAppBar = true,
    this.fab,
    this.appDrawer,
    this.appBarActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavBar,
    this.appBarBottom,
    this.appBarSubTitle,
    this.backgroundColor,
    this.menuActions,
    this.persistentFooterButtons,
    this.centerTitle = false,
    this.useLogo = false,
    this.overrideSingleScrollRoot = false,
    this.pageLoading = false,
    this.useDropDown = false,
    this.underDevelopment = false,
    this.showLogout = false,
  }) : super(key: key);

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  List<Widget>? actions;
  @override
  void initState() {
    if (CheckInternetService().listener != null) {
      CheckInternetService().listener!.cancel();
    }
    CheckInternetService().checkConnection();

    var menuActions = widget.menuActions;
    if (menuActions != null && menuActions.isNotEmpty) {
      actions = <Widget>[
        PopupMenuButton<String>(
          onSelected: (value) {
            var selectedAction = menuActions
                .firstWhereOrNull((menuItem) => menuItem.reference == value);
            if (selectedAction != null) {
              selectedAction.onClick();
            }
          },
          itemBuilder: (BuildContext context) {
            return menuActions.map((AppContainerAction action) {
              return PopupMenuItem<String>(
                value: action.reference,
                child: Text(action.title),
              );
            }).toList();
          },
        ),
      ];
    }

    var menuActionButton = widget.appBarActionButton;
    if (menuActionButton != null) {
      if (menuActions == null) {
        actions = [menuActionButton];
      } else {
        final actionsList = actions;
        if (actionsList != null) {
          actions = [menuActionButton];
          actionsList.insert(0, menuActionButton);
          actions = actionsList;
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if (CheckInternetService().listener != null) {
      CheckInternetService().listener!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.showAppBar
          ? AppBar(
              centerTitle: widget.centerTitle,
              elevation: 1,
              bottom: widget.appBarBottom,
              title: widget.useLogo
                  ? Image.asset(
                      AppImage.logo,
                      width: 40,
                      height: 40,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          AppString.title == widget.appBarTitle
                              ? widget.appBarTitle.toUpperCase()
                              : widget.appBarTitle.toUpperCase(),
                          minFontSize: 10,
                          style: SharedStyleUtil.appBarTitleTextStyle.copyWith(
                            color: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                          ),
                        ),
                        if (widget.appBarSubTitle != null)
                          AutoSizeText(
                            widget.appBarSubTitle?.toTitleCase() ?? '',
                            minFontSize: 4,
                            style: SharedStyleUtil.appBarSubTitleTextStyle
                                .copyWith(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.color,
                            ),
                          )
                      ],
                    ),
              //centerTitle: true,
              actions: actions,
            )
          : null,
      body: SafeArea(
        child: widget.overrideSingleScrollRoot
            ? widget.underDevelopment
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil.screenHeight(context) * 0.05),
                    child: NoticeCard(
                      title: widget.appBarTitle,
                      message: 'This feature will be coming soon.',
                    ),
                  )
                : widget.pageLoading
                    ? const LoadingProgress()
                    : widget.containerBody
            : SingleChildScrollView(
                child: widget.underDevelopment
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil.screenHeight(context) * 0.07),
                        child: NoticeCard(
                          title: widget.appBarTitle,
                          message: 'This feature will be coming soon.',
                        ),
                      )
                    : widget.pageLoading
                        ? const LoadingProgress()
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: widget.containerBody,
                          ),
              ),
      ),
      floatingActionButton: widget.fab,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      drawer: widget.appDrawer,
      persistentFooterButtons: widget.persistentFooterButtons,
      bottomNavigationBar: widget.bottomNavBar,
    );
  }
}
