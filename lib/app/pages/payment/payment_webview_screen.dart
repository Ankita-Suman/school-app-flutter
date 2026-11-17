import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  /// URL patterns jinme mile to success maana jayega.
  /// Apne gateway ke callback/return URL ke hisaab se customize karein.
  final List<String> successPatterns;

  /// URL patterns jinme mile to failure maana jayega.
  final List<String> failurePatterns;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.orderId,
    this.successPatterns = const [
      'success',
      'status=success',
      'txnstatus=success',
      'txn_status=success',
      'payment_status=success',
      'order_status=success',
      'payment/success',
      'payment-success',
    ],
    this.failurePatterns = const [
      'failure',
      'payment/failure',
      'payment-failure',
      'status=failed',
      'status=failure',
      'txnstatus=failed',
      'txn_status=failed',
      'payment_status=failed',
      'order_status=failed',
      'status=cancel',
      'status=cancelled',
      'payment/cancel',
    ],
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isHandled = false;        // double-fire se bachne ke liye
  bool _initialLoadDone = false;  // initial page load track karne ke liye

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
            _checkUrl(url);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
            _initialLoadDone = true;
            _checkUrl(url);
          },
          onProgress: (progress) {
            if (progress == 100 && mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            debugPrint("❌ WebView error: ${error.description}");
          },
          onNavigationRequest: (request) {
            if (_isHandled) return NavigationDecision.prevent;

            // Initial payment page load ko kabhi block mat karo
            if (!_initialLoadDone) return NavigationDecision.navigate;

            final handled = _checkUrl(request.url, preventNavigation: true);
            if (handled) return NavigationDecision.prevent;
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            if (change.url != null && _initialLoadDone) {
              _checkUrl(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Returns true agar URL handle ho gaya (success ya failure)
  bool _checkUrl(String url, {bool preventNavigation = false}) {
    if (_isHandled) return false;

    // Initial payment URL skip karo
    if (url.trim().toLowerCase() == widget.paymentUrl.trim().toLowerCase()) {
      return false;
    }

    final lower = url.toLowerCase();

    final isSuccess = widget.successPatterns
        .any((p) => lower.contains(p.toLowerCase()));

    final isFailure = !isSuccess &&
        widget.failurePatterns.any((p) => lower.contains(p.toLowerCase()));

    debugPrint("🔎 WebView URL check: $url");
    debugPrint("    success=$isSuccess failure=$isFailure");

    if (isSuccess) {
      _handleSuccess();
      return true;
    }
    if (isFailure) {
      _handleFailure();
      return true;
    }
    return false;
  }

  // ==========================================================
  // ✅ SUCCESS HANDLER
  // ==========================================================
  void _handleSuccess() {
    if (_isHandled) return;
    _isHandled = true;
    debugPrint("✅ Payment SUCCESS detected for order: ${widget.orderId}");

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: ${widget.orderId}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
              Get.back(result: {
                'success': true,
                'orderId': widget.orderId,
              }); // close WebView and return result
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ❌ FAILURE HANDLER
  // ==========================================================
  void _handleFailure() {
    if (_isHandled) return;
    _isHandled = true;
    debugPrint("❌ Payment FAILURE detected for order: ${widget.orderId}");

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text(
          'Your payment could not be completed. Please try again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(result: {
                'success': false,
                'orderId': widget.orderId,
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Complete Payment',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text('Cancel Payment?'),
                content: const Text(
                  'Are you sure you want to cancel the payment process?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // close confirm dialog
                      Get.back(result: {
                        'success': false,
                        'orderId': widget.orderId,
                        'cancelled': true,
                      }); // close WebView
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }
}