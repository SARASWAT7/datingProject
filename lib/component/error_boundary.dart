import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;

/// Comprehensive Error Boundary Widget
/// Prevents red screen crashes and shows user-friendly error messages
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String? fallbackTitle;
  final String? fallbackMessage;
  final VoidCallback? onRetry;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.fallbackTitle,
    this.fallbackMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  String? errorMessage;
  String? errorDetails;

  @override
  void initState() {
    super.initState();
    
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      dev.log('🚨 Flutter Error: ${details.exception}');
      dev.log('🚨 Stack trace: ${details.stack}');
      
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = _getUserFriendlyMessage(details.exception);
          errorDetails = details.exception.toString();
        });
      }
    };
  }

  String _getUserFriendlyMessage(dynamic error) {
    if (error.toString().contains('RangeError')) {
      return 'Oops! Something went wrong with the data. Let\'s refresh and try again.';
    } else if (error.toString().contains('NoSuchMethodError')) {
      return 'We\'re having trouble loading your data. Please try again.';
    } else if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('FormatException')) {
      return 'Data format error. Let\'s refresh and try again.';
    } else if (error.toString().contains('StateError')) {
      return 'App state error. Please restart the app.';
    } else {
      return 'Something unexpected happened. Don\'t worry, we\'re fixing it!';
    }
  }

  void _retry() {
    setState(() {
      hasError = false;
      errorMessage = null;
      errorDetails = null;
    });
    
    if (widget.onRetry != null) {
      widget.onRetry!();
    }
  }

  void _reportError() {
    // Copy error details to clipboard
    Clipboard.setData(ClipboardData(text: errorDetails ?? 'No error details'));
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error details copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorScreen();
    }
    
    return widget.child;
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade200, width: 2),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 60,
                  color: Colors.red.shade400,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Error Title
              Text(
                widget.fallbackTitle ?? 'Oops! Something went wrong',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error Message
              Text(
                widget.fallbackMessage ?? errorMessage ?? 'We\'re working to fix this issue.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Action Buttons
              Column(
                children: [
                  // Retry Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFD5564),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Report Error Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _reportError,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffFD5564), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bug_report_rounded, size: 20, color: Color(0xffFD5564)),
                          SizedBox(width: 8),
                          Text(
                            'Report Issue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffFD5564),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Help Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'If this keeps happening, please restart the app or contact support.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Safe array access utility
class SafeArrayAccess {
  static T? safeGet<T>(List<T>? list, int index) {
    if (list == null || index < 0 || index >= list.length) {
      return null;
    }
    return list[index];
  }
  
  static bool isValidIndex(List? list, int index) {
    return list != null && index >= 0 && index < list.length;
  }
  
  static int safeLength(List? list) {
    return list?.length ?? 0;
  }
}

/// Safe string operations
class SafeStringOps {
  static String safeSubstring(String? str, int start, [int? end]) {
    if (str == null || str.isEmpty) return '';
    if (start < 0) start = 0;
    if (end != null && end > str.length) end = str.length;
    if (start >= str.length) return '';
    return str.substring(start, end);
  }
  
  static List<String> safeSplit(String? str, String pattern) {
    if (str == null || str.isEmpty) return [];
    return str.split(pattern);
  }
}
