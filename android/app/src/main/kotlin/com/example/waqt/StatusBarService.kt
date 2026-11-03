package com.example.waqt

import android.app.Activity
import android.view.WindowManager

class StatusBarService(
    private val activity: Activity
) : StatusbarFlutterApi {

    override fun setColor(colorValue: Long) {
        activity.runOnUiThread {
            activity.window.statusBarColor = colorValue.toInt()
        }
    }
}
