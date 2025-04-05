import UIKit
import Flutter
import CheckoutComponentsSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let messenger = controller.binaryMessenger

        /// Register the MethodChannel
        let checkoutChannel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)

        checkoutChannel.setMethodCallHandler { (call, result) in
            if call.method == "initializeCheckout" {
                result(FlutterMethodNotImplemented) // We no longer present modally
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        let registrar = controller.registrar(forPlugin: "checkout_bridge")
        registrar?.register(CheckoutCardViewFactory1(messenger: messenger), withId: "flow_view_card")
        registrar?.register(CheckoutApplePayViewFactory1(messenger: messenger), withId: "flow_view_applepay")


        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
