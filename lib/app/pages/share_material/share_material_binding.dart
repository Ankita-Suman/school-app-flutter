import 'package:get/get.dart';

import 'share_material.dart';

/// A list of bindings which will be used in the route of [ShareMaterialScreen].
class ShareMaterialBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ShareMaterialController.new,
    );
  }
}
