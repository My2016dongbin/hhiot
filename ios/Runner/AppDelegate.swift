import UIKit
import Flutter
import AMapFoundationKit  // ✅ 导入高德基础库

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ 高德隐私设置

    AMapPrivacyUtility.showPrivacyInfoInWindow();


    AMapServices.shared().enableHTTPS = true
    // ✅ 设置高德地图 iOS 端 API Key（使用你提供的 Key）
    AMapServices.shared().apiKey = "818a6707000530b3a1d8a2b29a2bdd42"

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
