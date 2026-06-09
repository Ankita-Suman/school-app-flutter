import 'package:get/get.dart';

import 'payment.dart';

/// A list of bindings which will be used in the route of [PaymentScreen].
class PaymentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      PaymentController.new,
    );
  }
}
