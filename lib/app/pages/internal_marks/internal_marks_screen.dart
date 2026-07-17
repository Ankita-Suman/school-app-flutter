import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';

class InternalMarksScreen extends StatefulWidget {
  const InternalMarksScreen({super.key});

  @override
  State<InternalMarksScreen> createState() => _InternalMarksScreenState();
}

class _InternalMarksScreenState extends State<InternalMarksScreen> {
  // ========== STUDENT LIST DATA ==========
// ========== STUDENT LIST DATA ==========
  final List<Map<String, dynamic>> studentList = [
    {
      'name': 'Randeep Singh Jassal',
      'reg': '322',
      'roll': '1',
      'marks': '0',
      'isAbsent': false, // 🔥 Always boolean
    },
    {
      'name': 'Ridhman Kaur',
      'reg': '224',
      'roll': '112',
      'marks': '0',
      'isAbsent': false, // 🔥 Always boolean
    },
    {
      'name': 'Manvik Kumar Mishra',
      'reg': '236',
      'roll': '13',
      'marks': '0',
      'isAbsent': false, // 🔥 Always boolean
    },
  ];
  // ========== TEXT CONTROLLERS ==========
  final List<TextEditingController> markControllers = [];

  @override
  void initState() {
    super.initState();
    for (var student in studentList) {
      markControllers.add(TextEditingController(text: student['marks'] as String));
    }
  }

  @override
  void dispose() {
    for (var controller in markControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ========== HEADER BACKGROUND ==========
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              AssetConstants.icBlueBg,
              width: double.infinity,
              height: backgroundHeight,
              fit: BoxFit.cover,
            ),
          ),

          // ========== MAIN CONTENT ==========
          SafeArea(
            child: Column(
              children: [
                // ========== HEADER ==========
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: SvgPicture.asset(
                              AssetConstants.icBackBg,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Internal Marks', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== CONTAINER: SELECT CRITERIA ==========
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Criteria',
                                style: Styles.darkBlcW60015,
                              ),
                              const SizedBox(height: 12),

                              // ========== ROW 1: Exam Group & Subject ==========
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Exam Group',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Group-1',
                                                style: Styles.darkBlcW600,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Subject',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'English',
                                                style: Styles.darkBlcW600,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // ========== ROW 2: Class & Max Marks ==========
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Class',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Nursery - A',
                                                style: Styles.darkBlcW600,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Max Marks',
                                          style: Styles.darkBlueW400,
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '20',
                                                style: Styles.skyBlueW60012,
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey.shade600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========== CONTAINER: Enter Internal Marks ==========
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Internal Marks',
                                style: Styles.darkBlcW60015,
                              ),
                              const SizedBox(height: 12),

                              // ========== STUDENT LIST (Individual Containers) ==========
                              ...studentList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final student = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: _buildStudentRow(
                                    index: index,
                                    name: student['name'] as String? ?? '',
                                    reg: student['reg'] as String? ?? '',
                                    roll: student['roll'] as String? ?? '',
                                    isAbsent: student['isAbsent'] as bool? ?? false,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // ========== SAVE MARKS BUTTON ==========
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GradientButton(
                      onPressed: () {
                        for (int i = 0; i < studentList.length; i++) {
                          print('${studentList[i]['name']}: ${markControllers[i].text}');
                        }
                      },
                      text: 'Save Marks',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD STUDENT ROW ==========
  // ========== BUILD STUDENT ROW ==========
  Widget _buildStudentRow({
    required int index,
    required String name,
    required String reg,
    required String roll,
    required bool isAbsent,
  }) {
    return Row(
      children: [
        // ========== STUDENT NAME & DETAILS ==========
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Styles.darkBlcW70013,
              ),
              Text(
                '$reg $roll',
                style: Styles.darkBlueW400,
              ),
            ],
          ),
        ),

        // ========== ABSENT CHECKBOX ==========
        GestureDetector(
          onTap: () {
            setState(() {
              // 🔥 Ensure isAbsent is always a boolean
              bool currentValue = studentList[index]['isAbsent'] as bool? ?? false;
              studentList[index]['isAbsent'] = !currentValue;

              if (index < markControllers.length) {
                if (studentList[index]['isAbsent'] as bool) {
                  markControllers[index].text = '';
                } else {
                  markControllers[index].text = '0';
                }
              }
            });
          },
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isAbsent ? Colors.blue.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isAbsent ? Colors.blue.shade700 : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isAbsent
                    ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                'Absent',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isAbsent ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ========== MARKS INPUT ==========
        Container(
          width: 55,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: TextField(
            controller: index < markControllers.length ? markControllers[index] : null,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: Styles.skyBlueW60012,
            enabled: !isAbsent,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8), // 🔥 Vertical padding
              hintText: '0',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
            onChanged: (value) {
              studentList[index]['marks'] = value.isEmpty ? '0' : value;
            },
          ),
        ),      ],
    );
  }
}