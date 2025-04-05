package com.example.flow_flutter_new

import android.content.Context
import android.util.Log
import android.widget.FrameLayout
import androidx.activity.ComponentActivity
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.lifecycle.viewmodel.compose.viewModel
import com.checkout.components.core.CheckoutComponentsFactory
import com.checkout.components.interfaces.Environment
import com.checkout.components.interfaces.api.CheckoutComponents
import com.checkout.components.interfaces.component.CheckoutComponentConfiguration
import com.checkout.components.interfaces.error.CheckoutError
import com.checkout.components.interfaces.model.PaymentMethodName
import com.checkout.components.interfaces.model.PaymentSessionResponse
import com.checkout.components.wallet.wrapper.GooglePayFlowCoordinator
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.*

class GooglePayPlatformView(
    context: Context,
    args: Any?,
    messenger: BinaryMessenger
) : PlatformView {

    private val activity = context as FlutterFragmentActivity // ✅ REQUIRED
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
            Log.e("GooglePayPlatformView", "Missing session parameters")
//            return
        }

        val coordinator = GooglePayFlowCoordinator(
            context = activity, // ✅ Requires ComponentActivity
            handleActivityResult = { resultCode, data ->
                handleActivityResult(resultCode, data)

            }
        )

        Log.d("ContextType gpay flow", "Activity class: ${activity::class.java.name}")

        val flowCoordinators = mapOf(PaymentMethodName.GooglePay to coordinator)

        val configuration = CheckoutComponentConfiguration(
            context = activity,
            paymentSession = PaymentSessionResponse(
                id = sessionId,
                paymentSessionToken = "YmFzZTY0:eyJpZCI6InBzXzJ2SkZLSHJJOFZwZVVmZWVKTE1zVWxkUXFKRCIsImVudGl0eV9pZCI6ImVudF9uaHh2Y2phajc1NXJ3eno2emlkYXl5d29icSIsImV4cGVyaW1lbnRzIjp7fSwicHJvY2Vzc2luZ19jaGFubmVsX2lkIjoicGNfdGljZDZ0MnJybW51amFjYWthZnZ1a2hid3UiLCJhbW91bnQiOjEwMCwibG9jYWxlIjoiZW4tR0IiLCJjdXJyZW5jeSI6IkFFRCIsInBheW1lbnRfbWV0aG9kcyI6W3sidHlwZSI6ImNhcmQiLCJjYXJkX3NjaGVtZXMiOlsiVmlzYSIsIk1hc3RlcmNhcmQiXSwic2NoZW1lX2Nob2ljZV9lbmFibGVkIjpmYWxzZSwic3RvcmVfcGF5bWVudF9kZXRhaWxzIjoiZGlzYWJsZWQifSx7InR5cGUiOiJhcHBsZXBheSIsImRpc3BsYXlfbmFtZSI6InRlc3QiLCJjb3VudHJ5X2NvZGUiOiJTQSIsImN1cnJlbmN5X2NvZGUiOiJBRUQiLCJtZXJjaGFudF9jYXBhYmlsaXRpZXMiOlsic3VwcG9ydHMzRFMiXSwic3VwcG9ydGVkX25ldHdvcmtzIjpbInZpc2EiLCJtYXN0ZXJDYXJkIl0sInRvdGFsIjp7ImxhYmVsIjoidGVzdCIsInR5cGUiOiJmaW5hbCIsImFtb3VudCI6IjEifX0seyJ0eXBlIjoiZ29vZ2xlcGF5IiwibWVyY2hhbnQiOnsiaWQiOiIwODExMzA4OTM4NjI2ODg0OTk4MiIsIm5hbWUiOiJ0ZXN0Iiwib3JpZ2luIjoiaHR0cDovL2xvY2FsaG9zdDozMDAxIn0sInRyYW5zYWN0aW9uX2luZm8iOnsidG90YWxfcHJpY2Vfc3RhdHVzIjoiRklOQUwiLCJ0b3RhbF9wcmljZSI6IjEiLCJjb3VudHJ5X2NvZGUiOiJTQSIsImN1cnJlbmN5X2NvZGUiOiJBRUQifSwiY2FyZF9wYXJhbWV0ZXJzIjp7ImFsbG93ZWRfYXV0aF9tZXRob2RzIjpbIlBBTl9PTkxZIiwiQ1JZUFRPR1JBTV8zRFMiXSwiYWxsb3dlZF9jYXJkX25ldHdvcmtzIjpbIlZJU0EiLCJNQVNURVJDQVJEIl19fSx7InR5cGUiOiJ0YW1hcmEiLCJjb3VudHJ5X2NhbGxpbmdfY29kZXMiOlsiOTcxIiwiOTciXX0seyJ0eXBlIjoidGFiYnkiLCJjb3VudHJ5X2NhbGxpbmdfY29kZXMiOlsiOTcxIl19XSwiZmVhdHVyZV9mbGFncyI6WyJhbmFseXRpY3Nfb2JzZXJ2YWJpbGl0eV9lbmFibGVkIiwiZ2V0X3dpdGhfcHVibGljX2tleV9lbmFibGVkIiwibG9nc19vYnNlcnZhYmlsaXR5X2VuYWJsZWQiLCJyaXNrX2pzX2VuYWJsZWQiLCJ1c2Vfbm9uX2JpY19pZGVhbF9pbnRlZ3JhdGlvbiJdLCJyaXNrIjp7ImVuYWJsZWQiOmZhbHNlfSwibWVyY2hhbnRfbmFtZSI6InRlc3QiLCJwYXltZW50X3Nlc3Npb25fc2VjcmV0IjoicHNzXzczNDhiODVlLTQzZmMtNDI3ZS04NmM1LWExMTFlOTM0NjMxMSIsInBheW1lbnRfdHlwZSI6IlJlZ3VsYXIiLCJpbnRlZ3JhdGlvbl9kb21haW4iOiJhcGkuc2FuZGJveC5jaGVja291dC5jb20ifQ==",
                paymentSessionSecret = sessionSecret
            ),
            publicKey = publicKey,
            environment = Environment.SANDBOX,
            flowCoordinators = flowCoordinators
        )

        container.setViewTreeLifecycleOwner(activity)

        scope.launch {
            try {
                checkoutComponents = CheckoutComponentsFactory(config = configuration).create()
                val gpayComponent = checkoutComponents.create(PaymentMethodName.GooglePay)

                if (gpayComponent.isAvailable()) {
                    withContext(Dispatchers.Main) {
                        val composeView = ComposeView(activity)
                        composeView.setContent {
                            gpayComponent.Render()
                        }
                        container.addView(composeView)
                    }
                } else {
                    Log.e("GooglePayPlatformView", "Google Pay component not available")
                }

            } catch (e: CheckoutError) {
                Log.e("GooglePayPlatformView", "Checkout error: ${e.message}")
                withContext(Dispatchers.Main) {
                    channel.invokeMethod("paymentError", e.message ?: "Unknown error")
                }
            }
        }
    }

    private fun handleActivityResult(resultCode: Int, data: String) {
        Log.d("handleactivityResult","ana hon")
        checkoutComponents?.handleActivityResult(resultCode, data)
    }

    override fun getView(): FrameLayout = container

    override fun dispose() {
        scope.cancel()
    }
}
