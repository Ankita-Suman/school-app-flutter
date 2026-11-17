// pages/login/my_children_list_binding.dart
import 'package:get/get.dart';

import 'my_children_list.dart';

/// A list of bindings which will be used in the route of [MyChildrenListScreen].
class MyChildrenListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyChildrenListController>(
      MyChildrenListController(),
    );
  }
}