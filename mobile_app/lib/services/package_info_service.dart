import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  late PackageInfo _packageInfo;

  /////////////////
  // Public Getters
  /////////////////
  String get appVersion => _packageInfo.version;

  String get buildVersion => _packageInfo.buildNumber;

  Future getAppPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}
