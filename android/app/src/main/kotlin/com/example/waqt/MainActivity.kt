package com.example.waqt

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "waqt/apps"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getApps" -> {
                    val intent = Intent(Intent.ACTION_MAIN).apply {
                        addCategory(Intent.CATEGORY_LAUNCHER)
                    }

                    val apps = packageManager
                        .queryIntentActivities(intent, 0)
                        .map {
                            mapOf(
                                "name" to it.loadLabel(packageManager).toString(),
                                "packageName" to it.activityInfo.packageName
                            )
                        }
                        .distinctBy { it["packageName"] }
                        .sortedBy { it["name"] as String }

                    result.success(apps)
                }

                "launchApp" -> {
                    val packageName =
                        call.argument<String>("packageName")

                    val launchIntent = packageName?.let {
                        packageManager.getLaunchIntentForPackage(it)
                    }

                    if (launchIntent != null) {
                        startActivity(launchIntent)
                        result.success(true)
                    } else {
                        result.error(
                            "NOT_FOUND",
                            "App cannot be launched",
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
