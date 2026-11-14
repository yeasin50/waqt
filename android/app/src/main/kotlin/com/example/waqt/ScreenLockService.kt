package com.mdyeasinsheikh.waqt

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

class ScreenLockService : AccessibilityService() {
    companion object {
        var instance: ScreenLockService? = null
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
    }

    override fun onInterrupt() {
    }

    override fun onUnbind(intent: android.content.Intent?): Boolean {
        instance = null
        return super.onUnbind(intent)
    }

    fun lockDevice() {
        performGlobalAction(GLOBAL_ACTION_LOCK_SCREEN)
    }
}
