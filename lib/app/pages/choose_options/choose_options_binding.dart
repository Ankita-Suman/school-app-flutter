import 'package:get/get.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';

/// A list of bindings which will be used in the route of [ChooseOptionsScreen].
class ChooseOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      ChooseOptionsController.new,
    );
  }
}
