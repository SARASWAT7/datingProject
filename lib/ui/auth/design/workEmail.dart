import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import '../../../component/apihelper/common.dart';
import '../../../component/apihelper/toster.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../cubit/login/logincubit.dart';
import '../cubit/login/loginstate.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginType {
  pePhone,
  peEmail,
  workEmail,
}

class WorkEmail extends StatefulWidget {
  const WorkEmail({Key? key}) : super(key: key);

  @override
  State<WorkEmail> createState() => _MyNumberState();
}

class _MyNumberState extends State<WorkEmail> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController workEmailController = TextEditingController();

  String? _deviceToken;
  bool showFlag = true;
  String countryCodee = "";
  String lat = "";
  String long = "";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _getDeviceToken();
    _getCurrentPosition();
  }

  Future<void> _getDeviceToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      if (token != null) {
        setState(() {
          _deviceToken = token;
        });
        print('Device Token: $_deviceToken');
      } else {
        print('Token retrieval is delayed.');
      }
    } catch (e) {
      print('Error retrieving device token: $e');
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat = position.latitude.toString();
        long = position.longitude.toString();
        _currentPosition = position;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('lat', lat);
      await prefs.setString('long', long);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable the services.'),
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }

    return true;
  }

  LoginType? determineLoginType() {
    if (numberController.text.trim().isNotEmpty) {
      return LoginType.pePhone;
    } else if (emailController.text.trim().isNotEmpty) {
      return LoginType.peEmail;
    } else if (workEmailController.text.trim().isNotEmpty) {
      return LoginType.workEmail;
    }
    return null;
  }

  // Email validation using regex
  bool _isValidEmail(String email) {
    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInCubit(),
      child: BlocBuilder<LogInCubit, LogInState>(
        builder: (context, state) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 45),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Image.asset(
                              'assets/images/backarrow.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 25),
                          AppText(
                            size: 20,
                            text: 'My Work Email is.',
                            color: Color(0xff1B1B1B),
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 7),
                          TextFieldWidget(
                            controller: workEmailController,
                            textFieldBorderColor: Colors.grey,
                            textInputType: TextInputType.emailAddress,
                            hint: 'Work Email',
                            hintColor: Colors.black,
                            textFieldTitleColor: Colors.black,
                            title: '',
                          ),
                          const SizedBox(height: 35),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                LoginType? loginType = determineLoginType();

                                // Prevent multiple credential fields being filled
                                if (numberController.text.trim().isNotEmpty &&
                                    emailController.text.trim().isNotEmpty &&
                                    workEmailController.text.trim().isNotEmpty) {
                                  showToast(context, 'Please select only one login credential.');
                                  return;
                                }

                                if ((numberController.text.trim().isNotEmpty &&
                                    emailController.text.trim().isNotEmpty) ||
                                    (numberController.text.trim().isNotEmpty &&
                                        workEmailController.text.trim().isNotEmpty) ||
                                    (emailController.text.trim().isNotEmpty &&
                                        workEmailController.text.trim().isNotEmpty)) {
                                  showToast(context, 'Please select only one login credential.');
                                  return;
                                }

                                // Validate the email
                                if (workEmailController.text.trim().isNotEmpty) {
                                  if (!_isValidEmail(workEmailController.text.trim())) {
                                    showToast(context, 'Please enter a valid work email.');
                                    return;
                                  }
                                }

                                if (loginType != null) {
                                  switch (loginType) {
                                    case LoginType.pePhone:
                                      context.read<LogInCubit>().login(
                                        context,
                                        countryCodee,
                                        numberController.text.trim(),
                                        lat,
                                        long,
                                        _deviceToken??"DGFHGJHKJLKUYIGUHIIHEFVWDIUBVJKBEJBV",
                                      );
                                      break;
                                    case LoginType.peEmail:
                                      context.read<LogInCubit>().email(
                                        context,
                                        "",
                                        emailController.text.trim(),
                                        lat,
                                        long,
                                        _deviceToken??"DGFHGJHKJLKUYIGUHIIHEFVWDIUBVJKBEJBV",
                                      );
                                      break;
                                    case LoginType.workEmail:
                                      context.read<LogInCubit>().email(
                                        context,
                                        "",
                                        workEmailController.text.trim(),
                                        lat,
                                        long,
                                        _deviceToken??"DGFHGJHKJLKUYIGUHIIHEFVWDIUBVJKBEJBV",
                                      );
                                      break;
                                  }
                                } else {
                                  showToast(context, 'Please fill only one field.');
                                }
                              },
                              child: const CustomButton(text: 'Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.status == ApiState.isLoading) AppLoader(),
            ],
          );
        },
      ),
    );
  }
}
