package com.example.waqt

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class WidgetPlatformViewFactory(
    private val appManager: AppManagerApiImpl
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(
        context: Context,
        viewId: Int,
        args: Any?
    ): PlatformView {
        val params = args as Map<*, *>
        val widgetId = (params["widgetId"] as Number).toInt()

        return WidgetPlatformView(context, widgetId, appManager)
    }
}
