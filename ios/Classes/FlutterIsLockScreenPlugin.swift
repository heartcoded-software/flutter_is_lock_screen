import Flutter
import UIKit

public class FlutterIsLockScreenPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "is_lock_screen", binaryMessenger: registrar.messenger())
        let instance = FlutterIsLockScreenPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "isLockScreen":
            return result(UIScreen.main.brightness == 0.0)
        case "getPlatformVersion":
            return result("iOS " + UIDevice.current.systemVersion)
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
}