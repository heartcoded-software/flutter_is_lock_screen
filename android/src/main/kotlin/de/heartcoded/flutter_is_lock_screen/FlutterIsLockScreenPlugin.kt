package de.heartcoded.flutter_is_lock_screen

import androidx.annotation.NonNull

import android.app.KeyguardManager
import android.content.Context
import android.os.Build
import android.os.PowerManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FlutterIsLockScreenPlugin */
class FlutterIsLockScreenPlugin(val registrarContext: Context? = null): FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var bindingContext : Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    bindingContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "is_lock_screen")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "isLockScreen" -> {
        val context = bindingContext ?: registrarContext
        ?: return result.error("NullContext", "Cannot access system service as context is null", null)

        val keyguardManager: KeyguardManager = context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        val inKeyguardRestrictedInputMode: Boolean = keyguardManager.inKeyguardRestrictedInputMode()

        val isLocked = if (inKeyguardRestrictedInputMode) {
          true
        } else {
          val powerManager: PowerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            !powerManager.isInteractive
          } else {
            !powerManager.isScreenOn
          }
        }
        return result.success(isLocked)
      }
      else -> {
        return result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
