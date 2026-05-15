import 'package:get/get.dart';

import 'notice_board.dart';

/// A list of bindings which will be used in the route of [NoticeBoardScreen].
class NoticeBoardBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      NoticeBoardController.new,
    );
  }
}
