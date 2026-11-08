package com.example.waqt

import android.content.Context
import android.graphics.Bitmap
import androidx.core.graphics.drawable.toBitmap
import java.io.ByteArrayOutputStream

fun drawableToByteArray(
    context: Context,
    packageName: String,
    resId: Int
): ByteArray? {
    if (resId == 0) return null

    return try {
        val drawable = context.packageManager
            .getResourcesForApplication(packageName)
            .getDrawable(resId, null)

        val stream = ByteArrayOutputStream()
        drawable.toBitmap().compress(Bitmap.CompressFormat.PNG, 100, stream)
        stream.toByteArray()
    } catch (e: Exception) {
        null
    }
}
