import 'package:school_app/domain/domain.dart';

import '../../../domain/models/events_response.dart';

class UpcomingEventsPresenter {
  UpcomingEventsPresenter(this.homeUseCases);

  final HomeUseCases homeUseCases;

  Future<EventsResponseModel?> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    return await homeUseCases.getAllEvents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }
}
