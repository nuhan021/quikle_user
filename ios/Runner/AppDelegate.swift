import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("AIzaSyD65cza7lynnmbhCN44gs7HupKMnuoU-bo")
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    let userInfo: [String: Any] = [
      "options": options,
      "openUrl": url
    ]

    NotificationCenter.default.post(
      name: Notification.Name("ApplicationOpenURLNotification"),
      object: nil,
      userInfo: userInfo
    )

    return true
  }
}
