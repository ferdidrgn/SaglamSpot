import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let didFinishLaunching = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "com.saglamspot/app_icon",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        guard call.method == "setAppLogo", let logo = call.arguments as? String else {
          result(FlutterMethodNotImplemented)
          return
        }
        let iconName = logo == "illustrated" ? "IllustratedAppIcon" : nil
        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error {
            result(FlutterError(
              code: "APP_ICON_UPDATE_FAILED",
              message: error.localizedDescription,
              details: nil
            ))
          } else {
            result(nil)
          }
        }
      }
    }
    return didFinishLaunching
  }
}
