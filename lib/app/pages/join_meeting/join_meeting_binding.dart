import 'package:get/get.dart';

import 'join_meeting.dart';

/// A list of bindings which will be used in the route of [JoinMeetingScreen].
class JoinMeetingBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      JoinMeetingController.new,
    );
  }
}
