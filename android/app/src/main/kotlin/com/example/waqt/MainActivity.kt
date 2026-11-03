package com.example.waqt

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

import android.content.BroadcastReceiver
import android.content.IntentFilter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "waqt/apps"

    private var appChangeCallback: AppChangeCallback? = null

    private val packageChangeReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action

            val eventType = when (action) {
                Intent.ACTION_PACKAGE_ADDED -> "added"
                Intent.ACTION_PACKAGE_REMOVED -> "removed"
                Intent.ACTION_PACKAGE_REPLACED -> "replaced" 
                Intent.ACTION_PACKAGE_CHANGED -> "changed" // app enabled/disabled
                else -> return
            }

            val packageName = intent.data?.schemeSpecificPart ?: return

            CoroutineScope(Dispatchers.Main).launch {
                appChangeCallback?.onAppChanged(packageName, eventType)
            }
        }
    }

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


        StatusbarFlutterApi.setUp(messenger, StatusBarService(this))

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
                else -> result.notImplemented()
            }
        }
    }



    override fun onStart() {
        super.onStart()
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_PACKAGE_ADDED)
            addAction(Intent.ACTION_PACKAGE_REMOVED)
            addAction(Intent.ACTION_PACKAGE_CHANGED)
            addAction(Intent.ACTION_PACKAGE_REPLACED)
            addDataScheme("package")
        }
        registerReceiver(packageChangeReceiver, filter)
    }

    override fun onStop() {
        super.onStop()
        unregisterReceiver(packageChangeReceiver)
    }


}
