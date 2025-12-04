import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;
  final VoidCallback onPaymentSuccess;
  final VoidCallback onPaymentFailed;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.orderId,
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppLoggerHelper.debug('Payment page started loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            _checkPaymentStatus(url);
          },
          onPageFinished: (String url) {
            AppLoggerHelper.debug('Payment page finished loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            _checkPaymentStatus(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            AppLoggerHelper.debug('Navigation request: ${request.url}');
            _checkPaymentStatus(request.url);
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            AppLoggerHelper.error(
              '❌ WebView error: ${error.description}',
              error,
            );
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkPaymentStatus(String url) {
    // Check if URL indicates payment success or failure
    // Cashfree success patterns:
    // - /links/response/ URLs (after payment completion)
    // - URLs containing 'success', 'payment_status=success', or 'status=success'

    final isResponseUrl =
        url.contains('/links/response/') || url.contains('/gateway/thankyou/');

    if (isResponseUrl) {
      // For Cashfree response URLs, we consider them as success
      // unless they explicitly contain failure indicators
      if (url.contains('failure') ||
          url.contains('payment_status=failed') ||
          url.contains('status=failed') ||
          url.contains('cancel')) {
        AppLoggerHelper.debug(
          '❌ Payment failed/cancelled detected from URL: $url',
        );
        _handlePaymentFailure();
      } else {
        AppLoggerHelper.debug('✅ Payment successful detected from URL: $url');
        _handlePaymentSuccess();
      }
    } else if (url.contains('success') ||
        url.contains('payment_status=success') ||
        url.contains('status=success')) {
      AppLoggerHelper.debug('✅ Payment successful detected from URL: $url');
      _handlePaymentSuccess();
    } else if (url.contains('failure') ||
        url.contains('payment_status=failed') ||
        url.contains('status=failed') ||
        url.contains('cancel')) {
      AppLoggerHelper.debug(
        '❌ Payment failed/cancelled detected from URL: $url',
      );
      _handlePaymentFailure();
    }
  }

  void _handlePaymentSuccess() {
    if (!mounted) return;

    // Remove this screen from navigation stack
    Navigator.of(context).pop();

    // Trigger success callback
    widget.onPaymentSuccess();
  }

  void _handlePaymentFailure() {
    if (!mounted) return;

    // Remove this screen from navigation stack
    Navigator.of(context).pop();

    // Trigger failure callback
    widget.onPaymentFailed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text('Cancel Payment?'),
                content: const Text(
                  'Are you sure you want to cancel this payment?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      _handlePaymentFailure();
                    },
                    child: const Text('Yes, Cancel'),
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
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading payment page...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
