// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? selectedPaymentMethod; // "applepay" or "card"

//   void showCardBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return FractionallySizedBox(
//           heightFactor: 0.5,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: PlatformCardView(),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void onSelect(String method) {
//     setState(() {
//       selectedPaymentMethod = method;
//     });

//     if (method == "card") {
//       Future.delayed(Duration(milliseconds: 100), showCardBottomSheet);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final showApplePay = selectedPaymentMethod == "applepay";

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text('Choose Payment Method'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0.5,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => onSelect("applepay"),
//                     child: Text("Pay with ApplePay/GPay"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => onSelect("card"),
//                     child: Text("Pay with Card"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => onSelect("flow"),
//                     child: Text("Pay with Flow"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 255, 208, 68),
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           if (showApplePay)
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 height: 160,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: PlatformApplePayView(),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // This view renders Apple Pay (iOS) or Google Pay (Android)
// class PlatformApplePayView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const sessionParams = {
//         'paymentSessionID': "ps_2vIyXhMSYdDgCkcBUT0LhkFqPsd",
//           'paymentSessionSecret': "pss_267823cf-8775-473e-a5cd-abf9f4cd6fba",
//       'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
//     };

//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       return UiKitView(
//         viewType: 'flow_view_applepay',
//         creationParams: sessionParams,
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.android) {
//       return AndroidView(
//         viewType: 'flow_googlepay_view',
//         creationParams: sessionParams,
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else {
//       return Center(child: Text("Unsupported platform"));
//     }
//   }
// }

// // This view renders the Card UI
// class PlatformCardView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const sessionParams = {
//      'paymentSessionID': "ps_2vIyXhMSYdDgCkcBUT0LhkFqPsd",
//           'paymentSessionSecret': "pss_267823cf-8775-473e-a5cd-abf9f4cd6fba",
//       'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
//     };

//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       return UiKitView(
//         viewType: 'flow_view_card',
//         creationParams: sessionParams,
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.android) {
//       return AndroidView(
//         viewType: 'flow_card_view',
//         creationParams: sessionParams,
//         creationParamsCodec: const StandardMessageCodec(),
//       );
//     } else {
//       return Center(child: Text("Unsupported platform"));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedPaymentMethod;

  void showCardBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PlatformCardView(),
            ),
          ),
        );
      },
    );
  }

  void showFlowBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PlatformFlowView(),
            ),
          ),
        );
      },
    );
  }

  void onSelect(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });

    if (method == "card") {
      Future.delayed(Duration(milliseconds: 100), showCardBottomSheet);
    } else if (method == "flow") {
      Future.delayed(Duration(milliseconds: 100), showFlowBottomSheet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showApplePay = selectedPaymentMethod == "applepay";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Choose Payment Method'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onSelect("applepay"),
                    child: Center(
                      child: Text(
                        Platform.isIOS
                            ? "Pay with ApplePay"
                            : "Pay with GooglePay",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onSelect("card"),
                    child: Text("Pay with Card"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onSelect("flow"),
                    child: Text("Pay with Flow"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 208, 68),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          if (showApplePay)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PlatformApplePayView(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlatformApplePayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const sessionParams = {
      'paymentSessionID': "ps_2vJHh6AfvMkxQ38KJ9W3cLBzsay",
      'paymentSessionSecret': "pss_0800f53c-ab38-4bcd-811b-ef32aa289c78",
      'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flow_view_applepay',
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'flow_googlepay_view',
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Center(child: Text("Unsupported platform"));
    }
  }
}

class PlatformCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const sessionParams = {
      'paymentSessionID': "ps_2vJHh6AfvMkxQ38KJ9W3cLBzsay",
      'paymentSessionSecret': "pss_0800f53c-ab38-4bcd-811b-ef32aa289c78",
      'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flow_view_card',
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'flow_card_view',
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Center(child: Text("Unsupported platform"));
    }
  }
}

class PlatformFlowView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const sessionParams = {
      'paymentSessionID': "ps_2vJHh6AfvMkxQ38KJ9W3cLBzsay",
      'paymentSessionSecret': "pss_0800f53c-ab38-4bcd-811b-ef32aa289c78",
      'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flow_view_flow', // Update this if iOS view type is different
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType:
            'flow_flow_view', // Android view type registered in FlowViewFactory
        creationParams: sessionParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Center(child: Text("Unsupported platform"));
    }
  }
}
