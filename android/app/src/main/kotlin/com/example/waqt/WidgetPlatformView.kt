package com.example.waqt

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView

class WidgetPlatformView(
    context: Context,
    widgetId: Int,
    appManager: AppManagerApiImpl
) : PlatformView {

    private val widgetView: View = appManager.getWidgetView(widgetId)

    override fun getView(): View = widgetView

    override fun dispose() {}
}
