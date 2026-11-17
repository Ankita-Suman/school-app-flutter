import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../domain/models/document_response.dart';
import '../../app.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'student_documents_controller.dart';
import 'student_documents_presenter.dart';

class StudentDocumentsScreen extends StatelessWidget {
  const StudentDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<TeacherHomeUseCases>()) {
      Get.put(TeacherHomeUseCases(Get.find()));
    }

    final StudentDocumentsController controller = Get.put(
      StudentDocumentsController(
        StudentDocumentsPresenter(Get.find<TeacherHomeUseCases>()),
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight < 700 ? 90.0 : 110.0;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      extendBodyBehindAppBar: true,
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
                            child: SvgPicture.asset(AssetConstants.icBackBg),
                          ),
                          const SizedBox(width: 8),
                          Text('My Documents', style: Styles.whiteBold),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ========== SCROLLABLE CONTENT ==========
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    if (controller.documentsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              'No documents found',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Student Documents',
                                  style: Styles.darkBlcW700016,
                                ),
                              ),
                              // Dynamic List from API
                              ...controller.documentsList.asMap().entries.map((entry) {
                                final index = entry.key;
                                final doc = entry.value;
                                final isLast = index == controller.documentsList.length - 1;

                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 10,
                                    bottom: isLast ? 16 : 8,
                                  ),
                                  child: _buildDocumentCard(doc, context),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== BUILD DYNAMIC DOCUMENT CARD ==========
  Widget _buildDocumentCard(DocumentItem doc, BuildContext context) {
    final String baseUrl = 'https://demo.aitsolutions.in/';
    String fullImageUrl = '${baseUrl}${doc.filePath}';

    bool isPdf = doc.filePath?.toLowerCase().endsWith('.pdf') ?? false;

    return GestureDetector(
      onTap: () {
        if (isPdf) {
          // अगर पीडीएफ है तो अभी के लिए स्नैकबार दिखाएं (आप चाहें तो इसमें WebView या url_launcher लगा सकती हैं)
          Get.snackbar(
            'PDF Document',
            'Opening PDF: ${doc.title}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
        } else {
          // अगर इमेज है तो फुल-स्क्रीन ज़ूमेबल डायलॉग खोलें
          _showZoomableImageDialog(fullImageUrl);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // ========== IMAGE THUMBNAIL / PDF ICON ==========
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isPdf ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: isPdf
                  ? const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28)
                  : Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.blue, size: 28);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // ========== TITLE & DATE ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title ?? 'Untitled Document',
                    style: Styles.darkBlcW60015,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Uploaded: ${_formatDate(doc.createdAt)}',
                    style: Styles.darkBlueW400.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),

            // ========== ARROW ICON ==========
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ========== ✅ NEW: ZOOMABLE FULL SCREEN DIALOG ==========
  void _showZoomableImageDialog(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // Full screen
        child: Stack(
          children: [
            // Black Background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.95),
            ),

            // Interactive Viewer for Zoom/Pan
            Center(
              child: InteractiveViewer(
                minScale: 0.5, // कितना छोटा कर सकते हैं
                maxScale: 4.0, // कितना बड़ा (Zoom In) कर सकते हैं
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ),
            ),

            // Close Button (Top Right)
            Positioned(
              top: MediaQuery.of(Get.context!).padding.top + 10,
              right: 20,
              child: GestureDetector(
                onTap: () => Get.back(), // डायलॉग बंद करें
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),

            // Optional: Hint Text for User
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Pinch to Zoom',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true, // बाहर क्लिक करने पर बंद हो सकता है
    );
  }

  // Helper to format Date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime dt = DateTime.parse(dateString);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (e) {
      return dateString.split('T').first;
    }
  }
}