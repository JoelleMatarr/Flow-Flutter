import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CheckoutBridge {
  static const MethodChannel _channel = MethodChannel('checkout_bridge');

  // // Initialize Checkout and send Payment Session details to iOS
  // static Future<void> initializeCheckout({
  //   required String paymentSessionID,
  //   required String paymentSessionSecret,
  //   required String publicKey,
  // }) async {
  //   try {
  //     await _channel.invokeMethod('initializeCheckout', {
  //       'paymentSessionID': paymentSessionID,
  //       'paymentSessionSecret': paymentSessionSecret,
  //       'publicKey': publicKey,
  //     });
  //   } on PlatformException catch (e) {
  //     print("Error initializing Checkout: ${e.message}");
  //   }
  // }

  // ✅ Method to Listen for Payment Results from iOS
  static void listenForPaymentResults(BuildContext context) {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "paymentSuccess") {
        _showPaymentDialog(context, "Payment Successful", "Payment ID: ${call.arguments}");
      } else if (call.method == "paymentError") {
        _showPaymentDialog(context, "Payment Failed", "Error: ${call.arguments}");
      }
    });
  }

  // ✅ Function to Show Dialog
  static void _showPaymentDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
