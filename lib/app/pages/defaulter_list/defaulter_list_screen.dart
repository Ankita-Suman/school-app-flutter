// screens/defaulter_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app.dart';

class DefaulterListScreen extends StatefulWidget {
  const DefaulterListScreen({super.key});

  @override
  State<DefaulterListScreen> createState() => _DefaulterListScreenState();
}

class _DefaulterListScreenState extends State<DefaulterListScreen> {
  // ========== DEFAULTER DATA ==========
  final List<Map<String, dynamic>> defaulterList = [
    {
      'name': 'Isha Singh',
      'class': 'Class VI - A',
      'roll': '102',
      'overdueDays': '30',
      'pendingAmount': '₹15,000',
      'initial': 'I',
    },
    {
      'name': 'Kabir Das',
      'class': 'Class VII - B',
      'roll': '205',
      'overdueDays': '15',
      'pendingAmount': '₹20,000',
      'initial': 'K',
    },
    {
      'name': 'Rohan Patel',
      'class': 'Class VI - A',
      'roll': '103',
      'overdueDays': '45',
      'pendingAmount': '₹15,000',
      'initial': 'R',
    },
    {
      'name': 'Priya Sharma',
      'class': 'Class VIII - C',
      'roll': '312',
      'overdueDays': '10',
      'pendingAmount': '₹25,000',
      'initial': 'P',
    },
  ];

  // ========== CALCULATE TOTALS ==========
  int get totalStudents => defaulterList.length;
  int get totalPendingAmount {
    int total = 0;
    for (var student in defaulterList) {
      String amount = student['pendingAmount'] as String;
      // Remove ₹ and commas, convert to int
      String cleanAmount = amount.replaceAll('₹', '').replaceAll(',', '');
      total += int.parse(cleanAmount);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(
                          AssetConstants.icBackBg,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Defaulter List', style: Styles.whiteBold),
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
                        // ========== TOTAL PENDING DUES CARD (WHITE) ==========
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total Pending Dues',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${totalPendingAmount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Across $totalStudents Students',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ========== STUDENTS WITH OVERDUE FEES TITLE ==========
                        Text(
                          'Students with Overdue Fees',
                          style: Styles.darkBlcW700,
                        ),

                        const SizedBox(height: 12),

                        // ========== DEFAULTER LIST ==========
                        Column(
                          children: defaulterList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final student = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
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
                              child: _buildDefaulterCard(
                                name: student['name'] as String? ?? '',
                                classInfo: student['class'] as String? ?? '',
                                roll: student['roll'] as String? ?? '',
                                overdueDays: student['overdueDays'] as String? ?? '',
                                pendingAmount: student['pendingAmount'] as String? ?? '',
                                initial: student['initial'] as String? ?? '',
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),
                      ],
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

  // ========== BUILD DEFAULTER CARD ==========
  Widget _buildDefaulterCard({
    required String name,
    required String classInfo,
    required String roll,
    required String overdueDays,
    required String pendingAmount,
    required String initial,
  }) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========== ROW 1: Avatar, Name, Class/Roll ==========
        Row(
          children: [
            // ========== INITIAL AVATAR ==========
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ========== NAME & CLASS INFO ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Styles.darkBlcW70013,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$classInfo | Roll: $roll',
                    style: Styles.darkBlueW400,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ========== DIVIDER ==========
        Divider(
          color: Colors.grey.shade200,
          height: 1,
          thickness: 1,
        ),

        const SizedBox(height: 12),

        // ========== ROW 2: Overdue By & Pending Amount ==========
        Row(
          children: [
            // ========== OVERDUE BY ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overdue By',
                    style: Styles.darkBlueW40010,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$overdueDays Days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ========== PENDING AMOUNT ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pending Amount',
                    style: Styles.darkBlueW40010,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pendingAmount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}