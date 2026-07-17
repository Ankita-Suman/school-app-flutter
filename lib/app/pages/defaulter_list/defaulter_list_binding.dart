import 'package:get/get.dart';

import 'defaulter_list.dart';

/// A list of bindings which will be used in the route of [DefaulterListScreen].
class DefaulterListBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      DefaulterListController.new,
    );
  }
}
