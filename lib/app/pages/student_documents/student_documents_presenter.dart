
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../domain/models/document_response.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

class StudentDocumentsPresenter extends GetxController {
  StudentDocumentsPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<DocumentsResponse?> getStudentDocumentsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
  }) async {
    return await homeUseCases.getStudentDocumentsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }
}