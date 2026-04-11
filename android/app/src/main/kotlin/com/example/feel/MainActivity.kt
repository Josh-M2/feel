package com.example.feel

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "feel/widget_bridge",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getWidgetSupportStatus" -> {
                    val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
                    val canRequestPin =
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                            appWidgetManager.isRequestPinAppWidgetSupported
                    result.success(
                        mapOf(
                            "isSupported" to true,
                            "isConfigured" to true,
                            "canRequestPin" to canRequestPin,
                            "statusLabel" to "Ready",
                            "message" to "Android homescreen widget support is available on this device.",
                        ),
                    )
                }

                "syncDailyVersePayload" -> {
                    val payload = call.arguments as? Map<*, *>
                    if (payload == null) {
                        result.error("invalid_args", "Widget payload is missing.", null)
                        return@setMethodCallHandler
                    }

                    TodayWidgetPayloadStore.savePayload(applicationContext, payload)
                    TodayVerseAppWidgetProvider.refreshWidgets(applicationContext)
                    result.success(null)
                }

                "requestPinWidget" -> {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
                    if (!appWidgetManager.isRequestPinAppWidgetSupported) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    val provider = ComponentName(
                        applicationContext,
                        TodayVerseAppWidgetProvider::class.java,
                    )
                    result.success(appWidgetManager.requestPinAppWidget(provider, null, null))
                }

                else -> result.notImplemented()
            }
        }
    }
}
