import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import 'package:school_app/domain/domain.dart';
import 'widgets/widgets.dart';

class HomeController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedSliderIndex = 0;
  int selectedIndex = 0;
  DateTime date = DateTime.now();
  late var formattedDate='';
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
  List<EventsModel> eventsList = [
    EventsModel(name: "BAISAKHI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "HOLI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "DIWALI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "NEW YEAR CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "RAKHI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "BAISAKHI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "DUSSEHRA  CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "CHRISTMAS CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "HOLI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),
    EventsModel(name: "BAISAKHI CELEBRATION ",image: AssetConstants.icEvents,dec: 'Lorem ipsum dolor sit amet consectetur. Posuere amet lorem enim ornare lacus euismod. Maecenas pharetra sed vitae dignissim feugiat.'),

  ];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    formattedDate = DateFormat('d-MMM-yy').format(date);
  }

  void onSliderChanged(int index) {
    selectedSliderIndex = index;
    update();
  }

  void onSelectedTabChanged(int index) {
    selectedIndex = index;
    update();
  }

  Widget getItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const HomeWidget();
     case 1:
        return const HomeWorkWidget();
      case 2:
        return const TimeTableWidget();
      // case 3:
      //   return FavouritesWidget();
      // case 4:
      //   return ProfileWidget();
      default:
        return const HomeWidget();
    }
 }

  void setDate(DateTime selectedDate) {
    date = selectedDate;
    formattedDate = DateFormat('d-MMM-yy').format(selectedDate);
    update();
  }
}
