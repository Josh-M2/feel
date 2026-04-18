package com.example.feel

import android.appwidget.AppWidgetManager
import android.content.ClipData
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "feel/social_share",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareImage" -> {
                    val args = call.arguments as? Map<*, *>
                    val imageBytes = args?.get("imageBytes") as? ByteArray
                    val fileName = args?.get("fileName")?.toString()
                    if (imageBytes == null || fileName.isNullOrBlank()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    result.success(
                        shareImage(imageBytes = imageBytes, fileName = fileName),
                    )
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun shareImage(
        imageBytes: ByteArray,
        fileName: String,
    ): Boolean {
        val shareDirectory = File(cacheDir, "social_share").apply {
            mkdirs()
        }
        val shareFile = File(shareDirectory, fileName).apply {
            writeBytes(imageBytes)
        }
        val shareUri = FileProvider.getUriForFile(
            applicationContext,
            "${applicationContext.packageName}.fileprovider",
            shareFile,
        )

        val fallbackIntent = Intent(Intent.ACTION_SEND).apply {
            type = "image/png"
            putExtra(Intent.EXTRA_STREAM, shareUri)
            clipData = ClipData.newUri(contentResolver, fileName, shareUri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        val chooserIntent = Intent.createChooser(
            fallbackIntent,
            "Share verse image",
        ).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return if (chooserIntent.resolveActivity(packageManager) != null) {
            startActivity(chooserIntent)
            true
        } else {
            false
        }
    }
}
