
import '../../../domain/models/exam_group_response.dart';
import '../../../domain/models/exam_term_response.dart';
import '../../../domain/models/student_fee_status_response.dart';
import '../../../domain/models/term_class_response.dart';
import '../../../domain/models/term_section_response.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

class StudentFeeListPresenter {
  StudentFeeListPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<TermClassResponse?> getTermClassData(
      {required bool isLoading,
        required String token,
        required String branchId}) async {
    return await homeUseCases.getTermClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }


  Future<TermSectionResponse?> getTermSectionData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId}) async {
    return await homeUseCases.getTermSectionData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
    );
  }

  Future<StudentFeeStatusResponse?> getStudentFeeList(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId,
        required String sectionId,
      }) async {
    return await homeUseCases.getStudentFeeList(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
  }
}
