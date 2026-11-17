
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../domain/models/document_response.dart';
import '../../../domain/models/my_classmates_response.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

class MyClassmatesPresenter extends GetxController {
  MyClassmatesPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  // ✅ Classmates API के लिए मेथड
  Future<ClassmatesResponse?> getClassmatesAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    return await homeUseCases.getClassmatesAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }
}