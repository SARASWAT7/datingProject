// ignore_for_file: unnecessary_string_escapes, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../alert_box.dart';
import '../error_boundary.dart';

class DynamicSize {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class NormalMessage {
  NormalMessage._();

  static final NormalMessage _instance = NormalMessage._();

  factory NormalMessage() {
    return _instance;
  }
  static NormalMessage get instance => _instance;

  String googleloginsuccess = "Google Login SuccessFully";
  String passwordMessage =
      "Password should be Between 8-16 characters long. And it should contain Atleast One Number, One Special Character,One Uppercase and One Lowercase.";
  String emailMessage = "Please enter valid Email ID";
  String passwordmsg = "Please enter password";
  String customersign = "Customer Signature";
  String employesign = "Employee Signature";
  String phoneoremailMessage =
      "Please enter valid email address or phone number.";
  String firstNameEmpty = "Please enter first name";
  String emailEmpty = "Please enter Email ID.";
  String addremark = "Please add remark.";
  String IMAGES = "Please select document.";
  String photo = "Please select photo.";
  String otpEmpty = "Please enter OTP.";
  String description = "Please enter description.";
  String otplessEmpty = "Please enter OTP 4 digit.";
  String passwordEmpty = "Please enter password";
  String newpasswordEmpty = "Please enter new password";
  String datempty = "Please enter material date.";
  String Material_Vender_No = "Please enter Material Vendor No";
  String Material_Name = "Please enter Material Name.";
  String Number_item = "Please enter Material Number item";
  String Material_Price = "Please enter Material Price.";
  String confirmpasswordEmpty = "Please enter confirm password";
  String oldpasswordEmpty = "Please enter old password";
  String phonetext = "Please enter phone number";
  String feedback = "Please enter feedback";
  String contactUs = "Please enter message";
  String selectphoto = "Please select photo";
  String bio = "Please enter bio";
  String passion = "Please select passion";
  String phonenovalid = "Please enter valid phone number";
  String confirmpasswordValidation =
      "New Password & Confirm Password must be same.";
  String mainconfirmpasswordValidation =
      "New Password & Confirm Password must be same.";
  var phoneoremail = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String onlycharvalidation =
      "Name should not contain any special characters or numbers!";
  RegExp validateEmail = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  RegExp firstName = RegExp(r"^[A-Za-z,a-zA-Z]{1,15}$");
  RegExp validationName = RegExp(r'^[A-Z a-z]+$');

  RegExp validatePassword = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$',
  );
  bool checkemail(String email) {
    try {
      if (validateEmail.hasMatch(email) == true) {
        List data = SafeStringOps.safeSplit(email, "@");
        
        // SAFE CHECK: Ensure we have at least 2 parts after splitting by "@"
        if (data.length < 2) {
          return false;
        }
        
        List data1 = SafeStringOps.safeSplit(data[1], ".");

        if (data1.length > 2) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      // If any error occurs during email validation, return false
      return false;
    }
  }

  final RegExp phoneNumberRegex = RegExp(r'^(\+)?[0-9]{6,15}$');
  // String baseUrl = "https://dev.webmobrildemo.com/parqd";
  // String baseUrl = "http://44.217.173.175";
  // RegExp validateNumber = RegExp(r'[0-9]{10,12}$)');
  RegExp fullname = RegExp(r'^(?=.*[A-Za-z]).{2,}');
  RegExp phonenumbervalidate = RegExp(r'^[0-9]');
  String connecting = "Connecting...";
  String loading = "Please wait...";
  String serverError = "Server not responding, Please retry";
  String unauthenticatedError = "Unauthenticated";
  String somethingWentWrong = "Something went wrong.";
  String unableToParse = "Issue in Response Parsing";
  String endPointError = "Method end point is in-correct";
  String successfullyParse = "done";
  String internetConnectionError =
      "You have no internet connection. Please enable Wi-fi or Mobile Data and try again";
  String unauthenticatedmessage =
      "You have been logged out of the app. Please try logging in again.";
  normalerrorstate(BuildContext context, String message) async {
    try {
      // Check if the context is still valid before showing dialog
      if (!context.mounted) {
        if (kDebugMode) {
          print('Context is no longer valid, cannot show dialog for: $message');
        }
        return;
      }

      /*if (message == "NO DATA FOUND") {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else */
      if (message == "Null check operator used on a null value" ||
          message == "Throw of null.") {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertBox(title: serverError),
          );
        }
      } else if (message ==
              "type 'String' is not a subtype of type 'Map<String, dynamic>'" ||
          message ==
              "type '_TypeError' is not a subtype of type 'DioException' in type cast" ||
          message ==
              "type '_TypeError' is not a subtype of type 'DioError' in type cast") {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => const AlertBox(title: "Something went wrong"),
          );
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertBox(title: message),
          );
        }
      }
    } catch (e) {
      // Log error to console in debug mode
      if (kDebugMode) {
        print('Error in normalerrorstate: $e');
      }
      // Only show dialog if context is still valid
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertBox(title: "An unexpected error occurred"),
        );
      }
    }
  }
}
