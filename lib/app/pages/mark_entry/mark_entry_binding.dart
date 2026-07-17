import 'package:get/get.dart';

import 'mark_entry.dart';

/// A list of bindings which will be used in the route of [MarkEntryScreen].
class MarkEntryBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      MarkEntryController.new,
    );
  }
}
