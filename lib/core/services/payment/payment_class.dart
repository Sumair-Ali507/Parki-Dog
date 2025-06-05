import 'package:pay/pay.dart';

import '../../../features/shop/data/item_model.dart';
import '../../../features/shop/data/payment_model.dart';

class PaymentClass {
  static final List<PaymentItem> paymentItem = [];

  static Pay payClient = Pay({
    PayProvider.google_pay: PaymentConfiguration.fromJsonString(defaultApplePay),
    PayProvider.apple_pay: PaymentConfiguration.fromJsonString(defaultGooglePay),
  });

  static void onGooglePayPressed() async {
    final result = await payClient.showPaymentSelector(
      PayProvider.google_pay,
      paymentItem,
    );
  }

  static void onApplePayPressed() async {
    final result = await payClient.showPaymentSelector(
      PayProvider.apple_pay,
      paymentItem,
    );
  }

  static void changeBagToPayItem({required List<ItemDetails> itemDetails}) {
    for (var item in itemDetails) {
      paymentItem.add(
        PaymentItem(
          amount: '${item.price}',
          label: item.name,
          status: PaymentItemStatus.final_price,
        ),
      );
    }
  }
}
