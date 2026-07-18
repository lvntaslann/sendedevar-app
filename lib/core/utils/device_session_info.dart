import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceSessionInfo {
  static Future<Map<String, dynamic>> collect() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    String deviceModel = "Bilinmiyor";
    String osVersion = "Bilinmiyor";

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceModel = "${info.manufacturer} ${info.model}";
        osVersion = "Android ${info.version.release} (SDK ${info.version.sdkInt})";
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceModel = info.utsname.machine;
        osVersion = "iOS ${info.systemVersion}";
      } else if (Platform.isWindows) {
        final info = await deviceInfo.windowsInfo;
        deviceModel = info.computerName;
        osVersion = "Windows ${info.displayVersion}";
      } else if (Platform.isMacOS) {
        final info = await deviceInfo.macOsInfo;
        deviceModel = info.model;
        osVersion = "macOS ${info.osRelease}";
      } else if (Platform.isLinux) {
        final info = await deviceInfo.linuxInfo;
        deviceModel = info.prettyName;
        osVersion = info.version ?? "Linux";
      }
    } catch (_) {}

    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': "${packageInfo.version}+${packageInfo.buildNumber}",
    };
  }
}
