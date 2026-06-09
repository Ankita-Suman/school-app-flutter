import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/home_usecases.dart';
import 'upcoming_events.dart';

/// A list of bindings which will be used in the route of [UpcomingEventsScreen].
class UpcomingEventsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<UpcomingEventsController>(
      UpcomingEventsController(
        Get.put(
          UpcomingEventsPresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
