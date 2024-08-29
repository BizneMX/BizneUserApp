import UIKit
import FirebaseMessaging
import Flutter
import GoogleMaps
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL_SHARED_PREFS = "mx.devbizne.bizne/shared_preferences"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        if #available(iOS 10.0, *) {
            UIView.setAnimationsEnabled(false)
            
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            }
      
      application.registerForRemoteNotifications()
      
    GMSServices.provideAPIKey("AIzaSyCjOMPkc0bqoUvIfNZPA9D-A98G-gCSczU")
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let sharedPrefsChannel = FlutterMethodChannel(name: CHANNEL_SHARED_PREFS, binaryMessenger: controller.binaryMessenger)

    sharedPrefsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getSharedPreferencesValue" {
        if let args = call.arguments as? [String: Any],
           let key = args["key"] as? String {
          result(self.getSharedPreferencesValue(forKey: key))
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func getSharedPreferencesValue(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
    }
}
