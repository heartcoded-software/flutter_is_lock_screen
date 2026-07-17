import Flutter
import LocalAuthentication
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
            // iOS offers no direct "is the device locked" API. The previous
            // implementation compared UIScreen.main.brightness to 0.0, which is
            // the brightness *setting*, not the display or lock state: a locked
            // device usually still reports the user's brightness, and a lit
            // lock screen (raise-to-wake) reports > 0 as well — both produced
            // false "unlocked" answers from background execution contexts.
            //
            // Three-step check, closest available equivalent of the Android
            // Keyguard/PowerManager check:
            //
            // 1. App active in the foreground → the device is unlocked.
            if UIApplication.shared.applicationState == .active {
                return result(false)
            }
            // 2. A device passcode is set → protected-data availability
            //    mirrors the lock state and is readable from any background
            //    execution context: unavailable means locked, available means
            //    the device is unlocked right now (e.g. the user is using a
            //    different app). This is what enables background usage
            //    detection while this app is not in front.
            //
            //    brightness == 0.0 is added as a locked-hint: with "Require
            //    passcode after X minutes" the device counts as unlocked for
            //    up to X minutes after the display turns off; on iOS versions
            //    where a background brightness read drops to 0 with the
            //    display off, this closes part of that window. It is a weak,
            //    undocumented signal and is therefore only allowed to push
            //    the answer toward "locked" — never toward "unlocked".
            if LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                let locked = !UIApplication.shared.isProtectedDataAvailable
                    || UIScreen.main.brightness == 0.0
                return result(locked)
            }
            // 3. No passcode → protected data is always available and there
            //    is no signal left to distinguish "unlocked, other app in
            //    front" from "locked". Report locked: for callers a false
            //    "locked" is recoverable, a false "unlocked" fabricates
            //    device usage.
            return result(true)
        case "getPlatformVersion":
            return result("iOS " + UIDevice.current.systemVersion)
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
}