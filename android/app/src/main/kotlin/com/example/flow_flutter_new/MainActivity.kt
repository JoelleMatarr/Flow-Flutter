//package com.example.flow_flutter_new
//
//import android.util.Log
//import com.example.flow_flutter_new.CardViewFactory
//import com.example.flow_flutter_new.GooglePayViewFactory
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        flutterEngine
//            .platformViewsController
//            .registry
//            .registerViewFactory("flow_card_view", CardViewFactory())
//
//        flutterEngine
//            .platformViewsController
//            .registry
//            .registerViewFactory("flow_googlepay_view", GooglePayViewFactory())
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "checkout_bridge")
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//                    "initializeCheckout" -> {
//                        val sessionId = call.argument<String>("paymentSessionID")
//                        val sessionSecret = call.argument<String>("paymentSessionSecret")
//                        val publicKey = call.argument<String>("publicKey")
//
//                        Log.d("FlutterBridge", "Received: $sessionId, $sessionSecret, $publicKey")
//                        result.success(null)
//                    }
//                    else -> result.notImplemented()
//                }
//            }
//    }
//}


package com.example.flow_flutter_new

import android.util.Log
import com.example.flow_flutter_new.views.CardViewFactory
import com.example.flow_flutter_new.views.FlowViewFactory
import com.example.flow_flutter_new.views.GooglePayViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewRegistry

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "checkout_bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val registry: PlatformViewRegistry = flutterEngine.platformViewsController.registry

        // ✅ Pass messenger to factories
        registry.registerViewFactory("flow_card_view", CardViewFactory(messenger, this))
        registry.registerViewFactory("flow_googlepay_view", GooglePayViewFactory(messenger,this))
        registry.registerViewFactory("flow_flow_view", FlowViewFactory(messenger, this))

        // ✅ Set up MethodChannel (for future callbacks or control)
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeCheckout" -> {
                    val sessionId = call.argument<String>("paymentSessionID")
                    val sessionSecret = call.argument<String>("paymentSessionSecret")
                    val publicKey = call.argument<String>("publicKey")

                    Log.d("FlutterBridge", "Received: $sessionId, $sessionSecret, $publicKey")
                    result.success(null) // No-op since everything is in PlatformView
                }
                else -> result.notImplemented()
            }
        }
    }
}