import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../widgets/gradient_button.dart';

class MarkEntryScreen extends StatefulWidget {
  const MarkEntryScreen({super.key});

  @override
  State<MarkEntryScreen> createState() => _MarkEntryScreenState();
}

class _MarkEntryScreenState extends State<MarkEntryScreen> {
  // ========== EXAM DATA ==========
  final Map<String, dynamic> examData = {
    'examType': 'Mid Term 2026',
    'subject': 'Mathematics',
    'maxMarks': '100',
    'passing': '40',
  };

  // ========== STUDENT LIST DATA ==========
  final List<Map<String, dynamic>> studentList = [
    {
      'name': 'Aarav Sharma',
      'roll': '101',
      'marks': '0',
      'isAbsent': false,
    },
    {
      'name': 'Randeep Singh Jassal',
      'roll': '102',
      'marks': '0',
      'isAbsent': false,
    },
    {
      'name': 'Ridhman Kaur',
      'roll': '103',
      'marks': '0',
      'isAbsent': false,
    },
    {
      'name': 'Manvik Kumar Mishra',
      'roll': '104',
      'marks': '0',
      'isAbsent': false,
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
                          Text('Mark Entry', style: Styles.whiteBold),
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
                        // ========== EXAM TYPE & SUBJECT (Single Container) ==========
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.06),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // ========== ROW 1: Exam Type & Subject ==========
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Exam Type',
                                          style: Styles.darkBlueW40010,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          examData['examType'] as String,
                                          style: Styles.darkBlcW70013,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Vertical Divider
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.grey.shade300,
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
                                        Text(
                                          examData['subject'] as String,
                                          style: Styles.darkBlcW70013,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // ========== HORIZONTAL DIVIDER ==========
                               Divider(
                                color: Colors.grey.shade300,
                                height: 20,
                                thickness: 1,
                              ),

                              // ========== ROW 2: Max Marks & Passing ==========
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Max Marks: ${examData['maxMarks']}',
                                    style: Styles.darkBlueW400,
                                  ),
                                  Text(
                                    'Passing: ${examData['passing']}',
                                    style: Styles.darkBlueW400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ========== STUDENT LIST TITLE WITH COUNT ==========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Student List (VI - A)',
                              style: Styles.darkBlcW700,
                            ),
                            const SizedBox(width: 8),
                           Text(
                                '${studentList.length} Students',
                                style: Styles.skyBlueW60012
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ========== STUDENT LIST ==========
                        Column(
                            children: studentList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final student = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                  roll: student['roll'] as String? ?? '',
                                  marks: student['marks'] as String? ?? '0',
                                  isAbsent: student['isAbsent'] as bool? ?? false,
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // ========== SAVE MARK BUTTON (Fixed Bottom) ==========
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
                    child: ElevatedButton(
                      onPressed: () {
                        for (int i = 0; i < studentList.length; i++) {
                          print('${studentList[i]['name']}: ${markControllers[i].text}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Mark',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
  Widget _buildStudentRow({
    required int index,
    required String name,
    required String roll,
    required String marks,
    required bool isAbsent,
  }) {
    // Get initial from name
    String initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';

    // Get color based on initial
    Color getColor(String initial) {
      final colors = [
        Colors.blue,
        Colors.orange,
        Colors.green,
        Colors.purple,
        Colors.red,
        Colors.teal,
        Colors.pink,
        Colors.indigo,
      ];
      int index = initial.codeUnitAt(0) % colors.length;
      return colors[index];
    }

    Color avatarColor = getColor(initial);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // ========== INITIAL AVATAR ==========
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: avatarColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: avatarColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ========== STUDENT NAME & ROLL ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Styles.darkBlcW70013,
                ),
                Text(
                  'Roll: $roll',
                  style: Styles.darkBlueW400,
                ),
              ],
            ),
          ),

          // ========== MARKS INPUT (CENTER ALIGNED) ==========
          Container(
            width: 50,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Center(
              child: TextField(
                controller: index < markControllers.length ? markControllers[index] : null,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center, // 🔥 Center Aligned
                style: Styles.skyBlueW60012,
                enabled: !isAbsent,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  studentList[index]['marks'] = value.isEmpty ? '0' : value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}