import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Order Summary Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/keto.png', width: 50, height: 50),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Weight loss meal plan", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Keto by Foxxy", style: TextStyle(color: Colors.grey)),
                            Text("Breakfast + Lunch + Dinner + 2 Snacks", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Flow SDK Embedded Here
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 160, // adjust as needed based on Flow SDK height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PlatformView(), // Flow SDK with Apple Pay button
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlatformView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flow_view',
        creationParams: {
       'paymentSessionID': "ps_2vGtePZHetNPx7xSfyLdU2CShnH",
          'paymentSessionSecret': "pss_91cc989d-8e1d-43dd-886c-9ecff67cc6c2",
          'publicKey': "pk_sbox_cwlkrqiyfrfceqz2ggxodhda2yh",
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Center(child: Text("Unsupported platform"));
    }
  }
}
