import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let widgetChannelName = "feel/widget_bridge"
  private let socialShareChannelName = "feel/social_share"
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
      configureSocialShareBridge(binaryMessenger: controller.binaryMessenger)
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

  private func configureSocialShareBridge(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: socialShareChannelName, binaryMessenger: binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(false)
        return
      }

      switch call.method {
      case "shareImage":
        guard
          let args = call.arguments as? [String: Any],
          let imageData = (args["imageBytes"] as? FlutterStandardTypedData)?.data,
          !imageData.isEmpty
        else {
          result(false)
          return
        }

        DispatchQueue.main.async {
          result(self.shareImage(imageData: imageData))
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func shareImage(imageData: Data) -> Bool {
    guard let image = UIImage(data: imageData) else {
      return false
    }
    guard let presenter = topViewController() else {
      return false
    }

    let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    if let popover = controller.popoverPresentationController {
      popover.sourceView = presenter.view
      popover.sourceRect = CGRect(
        x: presenter.view.bounds.midX,
        y: presenter.view.bounds.maxY - 44,
        width: 1,
        height: 1
      )
    }
    presenter.present(controller, animated: true)
    return true
  }

  private func topViewController(base: UIViewController? = nil) -> UIViewController? {
    let rootController =
      base ??
      window?.rootViewController ??
      UIApplication.shared.connectedScenes
        .compactMap { scene in
          (scene as? UIWindowScene)?.windows.first(where: \.isKeyWindow)
        }
        .first?
        .rootViewController

    if let navigationController = rootController as? UINavigationController {
      return topViewController(base: navigationController.visibleViewController)
    }
    if let tabController = rootController as? UITabBarController {
      return topViewController(base: tabController.selectedViewController)
    }
    if let presented = rootController?.presentedViewController {
      return topViewController(base: presented)
    }
    return rootController
  }
}
