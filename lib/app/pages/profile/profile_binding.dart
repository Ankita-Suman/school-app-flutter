import 'package:get/get.dart';
import 'package:school_app/domain/domain.dart';

import 'profile.dart';

/// A list of bindings which will be used in the route of [ProfileScreen].
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(
      ProfileController(
        Get.put(
          ProfilePresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
