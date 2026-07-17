import 'package:get/get.dart';

import 'student_fee_list.dart';

/// A list of bindings which will be used in the route of [StudentFeeListScreen].
class StudentFeeListBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      StudentFeeListController.new,
    );
  }
}
