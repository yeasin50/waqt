package com.example.waqt

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "waqt/apps"


    private val adminComponent by lazy {
        ComponentName(this, MyDeviceAdminReceiver::class.java)
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        ScreenLockApi.setUp(messenger, ScreenLockApiImpl(this))

        appChangeCallback = AppChangeCallback(messenger) //The Listener (Kotlin to Dart)
        AppManagerApi.setUp(messenger, AppManagerApiImpl(this)) //The Commands (Dart to Kotlin)


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

                "openAppInfo" -> {
                    val packageName = call.arguments as String

                    val intent = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.parse("package:$packageName")
                    )
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)

                    result.success(true)
                }

                "uninstallApp" -> {
                   val packageName = call.arguments as String

                    try {
                        val intent = Intent(
                            Intent.ACTION_DELETE,
                            Uri.parse("package:$packageName")
                        )
                        intent.putExtra(Intent.EXTRA_RETURN_RESULT, true)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("UNINSTALL_FAILED", e.message, null)
                    }                
                }

                "requestLockPermission" -> {
                    val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
                        putExtra(
                            DevicePolicyManager.EXTRA_DEVICE_ADMIN,
                            ComponentName(context, MyDeviceAdminReceiver::class.java)
                        )
                        putExtra(
                            DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                            "Allow this app to lock the screen on double tap."
                        )
                    }

                    context.startActivity(intent)
                    result.success(true)
                }

                "checkLockPermission" -> {
                    val dpm = context.getSystemService(
                        Context.DEVICE_POLICY_SERVICE
                    ) as DevicePolicyManager

                    val admin = ComponentName(
                        context,
                        MyDeviceAdminReceiver::class.java
                    )
                    result.success(dpm.isAdminActive(admin))
                }

                "lockScreen" -> {
                    val devicePolicyManager =
                        getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager

                    if (devicePolicyManager.isAdminActive(adminComponent)) {
                        devicePolicyManager.lockNow()
                        result.success(true)
                    } else {
                        result.error("NOT_ADMIN", "Device admin not enabled", null)
                    }
                }



                else -> result.notImplemented()
            }
        }
    }
}
