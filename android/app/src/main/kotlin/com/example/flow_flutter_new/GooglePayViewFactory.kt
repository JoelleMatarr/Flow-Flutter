package com.example.flow_flutter_new.views

import android.content.Context
import androidx.activity.ComponentActivity
import com.example.flow_flutter_new.GooglePayPlatformView
import com.example.flow_flutter_new.MainActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class GooglePayViewFactory(private val messenger: BinaryMessenger,
                           private val activity: ComponentActivity
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return GooglePayPlatformView(activity, args, messenger)
    }
}
