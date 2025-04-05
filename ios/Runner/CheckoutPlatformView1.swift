import Foundation
import Flutter
import UIKit
import SwiftUI
import CheckoutComponentsSDK

@available(iOS 13.0, *)
class CheckoutCardPlatformView1: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        let containerView = UIView(frame: frame)
        _view = containerView
        super.init()

        guard
            let params = args as? [String: String],
            let paymentSessionID = params["paymentSessionID"],
            let paymentSessionSecret = params["paymentSessionSecret"],
            let publicKey = params["publicKey"]
        else {
            print("Invalid or missing parameters")
            return
        }

        let paymentSession = PaymentSession(id: paymentSessionID, paymentSessionSecret: paymentSessionSecret)

        Task {
            do {
                let config = try await CheckoutComponents.Configuration(
                    paymentSession: paymentSession,
                    publicKey: publicKey,
                    environment: .sandbox,
                    callbacks: .init(
                        onSuccess: { _, paymentID in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentSuccess", arguments: paymentID)
                        },
                        onError: { error in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentError", arguments: error.localizedDescription)
                        }
                    )
                )

                let checkout = CheckoutComponents(configuration: config)
                let component = try await checkout.create(.card())

                if component.isAvailable {
                    let controller = await UIHostingController(rootView: component.render())
                    DispatchQueue.main.async {
                        containerView.addSubview(controller.view)
                        controller.view.frame = containerView.bounds
                        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    }
                }

            } catch {
                print("Error rendering card component: \(error)")
            }
        }
    }

    func view() -> UIView {
        return _view
    }
}

@available(iOS 13.0, *)
class CheckoutApplePayPlatformView1: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        let containerView = UIView(frame: frame)
        _view = containerView
        super.init()

        guard
            let params = args as? [String: String],
            let paymentSessionID = params["paymentSessionID"],
            let paymentSessionSecret = params["paymentSessionSecret"],
            let publicKey = params["publicKey"]
        else {
            print("Invalid or missing parameters")
            return
        }

        let paymentSession = PaymentSession(id: paymentSessionID, paymentSessionSecret: paymentSessionSecret)

        Task {
            do {
                let config = try await CheckoutComponents.Configuration(
                    paymentSession: paymentSession,
                    publicKey: publicKey,
                    environment: .sandbox,
                    callbacks: .init(
                        onSuccess: { _, paymentID in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentSuccess", arguments: paymentID)
                        },
                        onError: { error in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentError", arguments: error.localizedDescription)
                        }
                    )
                )

                let checkout = CheckoutComponents(configuration: config)
                let component = try await checkout.create(.applePay(merchantIdentifier: "merchant.com.flowmobile.checkout"))

                if component.isAvailable {
                    let controller = await UIHostingController(rootView: component.render())
                    DispatchQueue.main.async {
                        containerView.addSubview(controller.view)
                        controller.view.frame = containerView.bounds
                        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    }
                }

            } catch {
                print("Error rendering Apple Pay component: \(error)")
            }
        }
    }

    func view() -> UIView {
        return _view
    }
}

class CheckoutCardViewFactory1: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        if #available(iOS 13.0, *) {
            return CheckoutCardPlatformView1(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger
            )
        } else {
            return DummyPlatformView1()
        }
    }
}

class CheckoutApplePayViewFactory1: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        if #available(iOS 13.0, *) {
            return CheckoutApplePayPlatformView1(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger
            )
        } else {
            return DummyPlatformView1()
        }
    }
}

class DummyPlatformView1: NSObject, FlutterPlatformView {
    func view() -> UIView {
        let label = UILabel()
        label.text = "Unsupported iOS Version"
        label.textAlignment = .center
        return label
    }
}


@available(iOS 13.0, *)
class CheckoutFlowPlatformView1: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        let containerView = UIView(frame: frame)
        _view = containerView
        super.init()

        guard
            let params = args as? [String: String],
            let paymentSessionID = params["paymentSessionID"],
            let paymentSessionSecret = params["paymentSessionSecret"],
            let publicKey = params["publicKey"]
        else {
            print("Invalid or missing parameters")
            return
        }

        let paymentSession = PaymentSession(id: paymentSessionID, paymentSessionSecret: paymentSessionSecret)

        Task {
            do {
                let config = try await CheckoutComponents.Configuration(
                    paymentSession: paymentSession,
                    publicKey: publicKey,
                    environment: .sandbox,
                    callbacks: .init(
                        onSuccess: { _, paymentID in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentSuccess", arguments: paymentID)
                        },
                        onError: { error in
                            let channel = FlutterMethodChannel(name: "checkout_bridge", binaryMessenger: messenger)
                            channel.invokeMethod("paymentError", arguments: error.localizedDescription)
                        }
                    )
                )

                let checkout = CheckoutComponents(configuration: config)
                let component = try await checkout.create(.flow(options: [
                    .applePay(merchantIdentifier: "merchant.com.flowmobile.checkout")
                    ]
                  )) // ✅ Create full Flow

                if component.isAvailable {
                    let controller = await UIHostingController(rootView: component.render())
                    DispatchQueue.main.async {
                        containerView.addSubview(controller.view)
                        controller.view.frame = containerView.bounds
                        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    }
                }

            } catch {
                print("Error rendering Flow component: \(error)")
            }
        }
    }

    func view() -> UIView {
        return _view
    }
}



class CheckoutFlowViewFactory1: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        if #available(iOS 13.0, *) {
            return CheckoutFlowPlatformView1(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args,
                binaryMessenger: messenger
            )
        } else {
            return DummyPlatformView1()
        }
    }
}
