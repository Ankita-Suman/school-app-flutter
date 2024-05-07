import 'package:flutter/material.dart';
import 'package:school_app/app/app.dart';
import 'package:get/get.dart';

import '../../../domain/models/academic_model.dart';

class HomeController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<AcademicModel> academicList = [
    AcademicModel(name: "Live Class",image: AssetConstants.icLiveClass),
    AcademicModel(name: "Teacher",image: AssetConstants.icTeachers),
    AcademicModel(name: "Lesson Plan",image: AssetConstants.iLessonPlan),
    AcademicModel(name: "Time Table",image: AssetConstants.icTimeTable),
    AcademicModel(name: "Assignment",image:  AssetConstants.icAssignment),
    AcademicModel(name: "Download Center",image:  AssetConstants.icDownload),
    AcademicModel(name: "Library",image:  AssetConstants.icLibrary),
    AcademicModel(name: "Calendar",image:  AssetConstants.icCalendar),
  ];
  List<AcademicModel> othersList = [
    AcademicModel(name: "Fees",image: AssetConstants.icFees),
    AcademicModel(name: "Notification",image: AssetConstants.icNotification),
    AcademicModel(name: "Document",image: AssetConstants.icDocument),
    AcademicModel(name: "Transport Route",image: AssetConstants.icRoute),
    AcademicModel(name: "Help & Support",image:  AssetConstants.icHelp),
    AcademicModel(name: "Settings",image:  AssetConstants.iSettings),
    AcademicModel(name: "User",image:  AssetConstants.icUser),
    AcademicModel(name: "Logout",image:  AssetConstants.icLogout),
  ];
}
