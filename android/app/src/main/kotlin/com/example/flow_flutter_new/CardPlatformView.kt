package com.example.flow_flutter_new

import android.app.Activity
import android.util.Log
import android.widget.FrameLayout
import androidx.compose.ui.platform.ComposeView
import com.checkout.components.core.CheckoutComponentsFactory
import com.checkout.components.interfaces.Environment
import com.checkout.components.interfaces.api.CheckoutComponents
import com.checkout.components.interfaces.component.CheckoutComponentConfiguration
import com.checkout.components.interfaces.component.ComponentCallback
import com.checkout.components.interfaces.component.ComponentOption
import com.checkout.components.interfaces.error.CheckoutError
import com.checkout.components.interfaces.model.PaymentMethodName
import com.checkout.components.interfaces.model.PaymentSessionResponse
import com.checkout.components.interfaces.model.paymentsession.PaymentSession
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.*

class CardPlatformView(
    private val activity: Activity, // ✅ Correct type passed from factory
    args: Any?,
    messenger: BinaryMessenger
) : PlatformView {

    private val container = FrameLayout(activity)
    private val channel = MethodChannel(messenger, "checkout_bridge")
    private val scope = CoroutineScope(Dispatchers.IO)
    private lateinit var checkoutComponents: CheckoutComponents

    init {
        val params = args as? Map<*, *> ?: emptyMap<String, String>()
        val sessionId = params["paymentSessionID"] as? String ?: ""
        val sessionSecret = params["paymentSessionSecret"] as? String ?: ""
        val publicKey = params["publicKey"] as? String ?: ""

        if (sessionId.isEmpty() || sessionSecret.isEmpty() || publicKey.isEmpty()) {
            Log.e("CardPlatformView", "Missing required session parameters")
//            return
        }

        val customComponentCallback = ComponentCallback(
            onReady = { component ->
                Log.d("flow component","test onReady "+component.name)
            },
            onSubmit = { component ->
                Log.d("flow component ","test onSubmit "+component.name)
            },
            onSuccess = { component, paymentID ->
                Log.d("flow payment success ${component.name}", paymentID)
            },
            onError = { component, checkoutError ->
                Log.d("flow callback Error","onError "+checkoutError.message+", "+checkoutError.code)
            },
        )

        val configuration = CheckoutComponentConfiguration(
            context = activity,
            paymentSession = PaymentSessionResponse(
                id = sessionId,
//                paymentSessionToken = "YmFzZTY0:eyJpZCI6InBzXzJ2T2t1ZzBnbXRFenNVY0g0cTZvRllGUExTMCIsImVudGl0eV9pZCI6ImVudF9uaHh2Y2phajc1NXJ3eno2emlkYXl5d29icSIsImV4cGVyaW1lbnRzIjp7fSwicHJvY2Vzc2luZ19jaGFubmVsX2lkIjoicGNfdGljZDZ0MnJybW51amFjYWthZnZ1a2hid3UiLCJhbW91bnQiOjEwMCwibG9jYWxlIjoiZW4tR0IiLCJjdXJyZW5jeSI6IlNBUiIsInBheW1lbnRfbWV0aG9kcyI6W3sidHlwZSI6ImNhcmQiLCJjYXJkX3NjaGVtZXMiOlsiVmlzYSIsIk1hc3RlcmNhcmQiXSwic2NoZW1lX2Nob2ljZV9lbmFibGVkIjpmYWxzZSwic3RvcmVfcGF5bWVudF9kZXRhaWxzIjoiZGlzYWJsZWQifSx7InR5cGUiOiJhcHBsZXBheSIsImRpc3BsYXlfbmFtZSI6InRlc3QiLCJjb3VudHJ5X2NvZGUiOiJTQSIsImN1cnJlbmN5X2NvZGUiOiJTQVIiLCJtZXJjaGFudF9jYXBhYmlsaXRpZXMiOlsic3VwcG9ydHMzRFMiXSwic3VwcG9ydGVkX25ldHdvcmtzIjpbInZpc2EiLCJtYXN0ZXJDYXJkIl0sInRvdGFsIjp7ImxhYmVsIjoidGVzdCIsInR5cGUiOiJmaW5hbCIsImFtb3VudCI6IjEifX0seyJ0eXBlIjoiZ29vZ2xlcGF5IiwibWVyY2hhbnQiOnsiaWQiOiIwODExMzA4OTM4NjI2ODg0OTk4MiIsIm5hbWUiOiJ0ZXN0Iiwib3JpZ2luIjoiaHR0cDovL2xvY2FsaG9zdDozMDAxIn0sInRyYW5zYWN0aW9uX2luZm8iOnsidG90YWxfcHJpY2Vfc3RhdHVzIjoiRklOQUwiLCJ0b3RhbF9wcmljZSI6IjEiLCJjb3VudHJ5X2NvZGUiOiJTQSIsImN1cnJlbmN5X2NvZGUiOiJTQVIifSwiY2FyZF9wYXJhbWV0ZXJzIjp7ImFsbG93ZWRfYXV0aF9tZXRob2RzIjpbIlBBTl9PTkxZIiwiQ1JZUFRPR1JBTV8zRFMiXSwiYWxsb3dlZF9jYXJkX25ldHdvcmtzIjpbIlZJU0EiLCJNQVNURVJDQVJEIl19fV0sImZlYXR1cmVfZmxhZ3MiOlsiYW5hbHl0aWNzX29ic2VydmFiaWxpdHlfZW5hYmxlZCIsImdldF93aXRoX3B1YmxpY19rZXlfZW5hYmxlZCIsImxvZ3Nfb2JzZXJ2YWJpbGl0eV9lbmFibGVkIiwicmlza19qc19lbmFibGVkIiwidXNlX25vbl9iaWNfaWRlYWxfaW50ZWdyYXRpb24iXSwicmlzayI6eyJlbmFibGVkIjpmYWxzZX0sIm1lcmNoYW50X25hbWUiOiJ0ZXN0IiwicGF5bWVudF9zZXNzaW9uX3NlY3JldCI6InBzc18xNDdkZmUyYi00YTg2LTQwMTItODg5Zi05MTUwYTdkMWNiODAiLCJwYXltZW50X3R5cGUiOiJSZWd1bGFyIiwiaW50ZWdyYXRpb25fZG9tYWluIjoiYXBpLnNhbmRib3guY2hlY2tvdXQuY29tIn0=",
                secret = sessionSecret
            ),
            publicKey = publicKey,
            environment = Environment.SANDBOX,
            componentCallback = customComponentCallback
        )

        scope.launch {
            try {
                checkoutComponents = CheckoutComponentsFactory(config = configuration).create()
                val flow = checkoutComponents.create(
                    PaymentMethodName.Card,
                    ComponentOption(showPayButton = true)
                )

                if (flow.isAvailable()) {
                    withContext(Dispatchers.Main) {
                        val composeView = ComposeView(activity)
                        composeView.setContent {
                            flow.Render()
                        }
                        container.addView(composeView)
                    }
                } else {
                    Log.e("CardPlatformView", "Card component not available")
                }
            } catch (e: CheckoutError) {
                Log.e("CardPlatformView", "Checkout error: ${e.message}")
                withContext(Dispatchers.Main) {
                    channel.invokeMethod("paymentError", e.message ?: "Unknown error")
                }
            }
        }
    }

    override fun getView(): FrameLayout = container

    override fun dispose() {
        scope.cancel()
    }
}
