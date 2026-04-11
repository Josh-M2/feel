import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let widgetChannelName = "feel/widget_bridge"
  private let widgetAppGroup = "group.com.example.feel.shared"
  private let widgetPayloadKey = "today_widget_payload"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let didFinishLaunching = super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    if let controller = window?.rootViewController as? FlutterViewController {
      configureWidgetBridge(binaryMessenger: controller.binaryMessenger)
    }

    return didFinishLaunching
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func configureWidgetBridge(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: widgetChannelName, binaryMessenger: binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(FlutterError(code: "unavailable", message: "App delegate is not available.", details: nil))
        return
      }

      switch call.method {
      case "getWidgetSupportStatus":
        let hasSharedDefaults = UserDefaults(suiteName: self.widgetAppGroup) != nil
        result([
          "isSupported": true,
          "isConfigured": hasSharedDefaults,
          "canRequestPin": false,
          "statusLabel": hasSharedDefaults ? "Ready" : "Needs App Group",
          "message": hasSharedDefaults
            ? "iOS homescreen widget support is available for this build."
            : "The iOS widget extension expects the shared App Group to be available."
        ])

      case "syncDailyVersePayload":
        guard let payload = call.arguments as? [String: Any] else {
          result(FlutterError(code: "invalid_args", message: "Widget payload is missing.", details: nil))
          return
        }

        guard let sharedDefaults = UserDefaults(suiteName: self.widgetAppGroup) else {
          result(FlutterError(code: "app_group_unavailable", message: "Shared App Group storage is not available.", details: nil))
          return
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: payload, options: [])
          sharedDefaults.set(data, forKey: self.widgetPayloadKey)
          sharedDefaults.synchronize()
          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
          }
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "payload_encode_failed",
              message: "Widget payload could not be encoded.",
              details: error.localizedDescription
            )
          )
        }

      case "requestPinWidget":
        result(false)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
