import 'package:get/get.dart';

import 'fee_collection.dart';

/// A list of bindings which will be used in the route of [FeeCollectionScreen].
class FeeCollectionBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      FeeCollectionController.new,
    );
  }
}
