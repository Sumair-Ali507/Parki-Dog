import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pay/pay.dart';

import '../../data/payment_model.dart';

class PaymentButton extends StatelessWidget {
  final List<PaymentItem> paymentItemList;
  final void Function()? onPressed;
  const PaymentButton({Key? key, required this.paymentItemList, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isAndroid
            ? GooglePayButton(
                onError: (v) {},
                onPressed: onPressed,
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                paymentItems: paymentItemList,
                type: GooglePayButtonType.order,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (V) {
                  print(V);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ApplePayButton(
                onPressed: onPressed,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
                paymentItems: paymentItemList,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.order,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (V) {
                  print(V);
                },
              ));
  }
}
