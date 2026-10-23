package com.example.waqt

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings 
import android.content.pm.PackageManager

class AppManagerApiImpl(private val context: Context) : AppManagerApi {

    override fun openAppInfo(packageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    override fun openApp(packageName: String): Boolean {
        val intent = context.packageManager.getLaunchIntentForPackage(packageName)
        return if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } else {
            false
        }
    }

    override fun uninstallApp(packageName: String) {
        val intent = Intent(Intent.ACTION_DELETE).apply {
            data = Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    override fun isDefaultLauncher(): Boolean {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
        }

        // get the current homeApp default
        val resolveInfo = context.packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        return resolveInfo?.activityInfo?.packageName == context.packageName
    }


    override fun requestDefaultLauncher() {
        //  since we passed 'this' from MainActivity
        val activity = context as? android.app.Activity

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            val roleManager = context.getSystemService(Context.ROLE_SERVICE) as android.app.role.RoleManager

            // ignore if already set
            if (roleManager.isRoleHeld(android.app.role.RoleManager.ROLE_HOME)) {
                return 
            }

            val intent = roleManager.createRequestRoleIntent(android.app.role.RoleManager.ROLE_HOME)
            activity?.startActivityForResult(intent, 1001) 

        } else {
            // Fallback for older Android versions
            val intent = Intent(android.provider.Settings.ACTION_HOME_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
    }
}
