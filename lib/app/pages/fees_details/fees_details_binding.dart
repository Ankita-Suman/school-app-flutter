import 'package:get/get.dart';

import 'fees_details.dart';

/// A list of bindings which will be used in the route of [FeesDetailsScreen].
class FeesDetailsBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      FeesDetailsController.new,
    );
  }
}
