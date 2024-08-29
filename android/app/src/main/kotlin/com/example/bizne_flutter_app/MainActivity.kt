package mx.devbizne.bizne

import android.content.Context
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL_ANDROID_ID = "mx.devbizne.bizne/android_id"
    private val CHANNEL_SHARED_PREFS = "mx.devbizne.bizne/shared_preferences"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_ANDROID_ID).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidID") {
                val androidId = getAndroidID()
                if (androidId != null) {
                    result.success(androidId)
                } else {
                    result.error("UNAVAILABLE", "Android ID unavailable.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SHARED_PREFS).setMethodCallHandler { call, result ->
            if (call.method == "getSharedPreferencesValue") {
                val key = call.argument<String>("key")
                val value = getSharedPreferencesValue(key)
                if (value != null) {
                    result.success(value)
                } else {
                    result.error("UNAVAILABLE", "Value unavailable.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidID(): String? {
        return Settings.Secure.getString(this.contentResolver, Settings.Secure.ANDROID_ID)
    }

    private fun getSharedPreferencesValue(key: String?): String? {
        val sharedPreferences = getSharedPreferences("mx.devbizne.bizne_preferences", Context.MODE_PRIVATE)
        return sharedPreferences.getString(key, null)
    }
}