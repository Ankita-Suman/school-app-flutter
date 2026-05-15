import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_app/app/app.dart';
import 'profile.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("=== StaffProfileScreen build called ===");
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: ColorsValue.primaryColor,
      body: Stack(
        children: <Widget>[
          // Header - Always visible
          Container(
            padding: const EdgeInsets.only(top: 5),
            height: Dimens.threeHundredSeventyFive,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: Dimens.edgeInsets20_55_20_10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: Get.back,
                          child: SizedBox(
                              height: Dimens.twenty,
                              width: Dimens.twenty,
                              child: SvgPicture.asset(
                                  AssetConstants.icBackArrow,
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                  fit: BoxFit.scaleDown))),
                      Text(StringConstants.profile, style: Styles.white30B),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: Dimens.edgeInsets0_5_0_0,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.asset(
                                    AssetConstants.icHomeNotification)),
                          ),
                          Dimens.boxHeight10,
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Bottom Container with content
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: Container(
                width: double.infinity,
                height: Dimens.percentHeight(0.82),
                color: Colors.white,
                child: Obx(() {
                  print("Obx rebuild - isLoading: ${controller.isLoading.value}");
                  print("Obx rebuild - profileData: ${controller.profileData.value != null ? 'has data' : 'null'}");

                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.profileData.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No profile data available'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => (){},
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Profile Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorsValue.lightSkyBgClr,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: ColorsValue.primaryColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 60, color: Color(0xFF4A5B8C)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   controller.get('name'),
                                    //   style: Styles.black20,
                                    // ),
                                    // const SizedBox(height: 4),
                                    // Text(
                                    //   controller.get('role'),
                                    //   style: Styles.grey12,
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Details
                        //_infoRow('Email', controller.get('email')),
                        const Divider(),
                       // _infoRow('Role', controller.get('role')),
                        const Divider(),
                        const SizedBox(height: 20),
                        // Logout
                        InkWell(
                          onTap: () => Get.dialog(
                            AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                   // controller.logoutAPI(isLoading: true);
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: Styles.grey12),
          ),
          Expanded(
            child: Text(
              value,
              style: Styles.darkGrey12,
            ),
          ),
        ],
      ),
    );
  }
}