import 'package:country_code_picker/country_code_picker.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../component/apihelper/common.dart';
import '../../../component/apihelper/toster.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../cubit/login/logincubit.dart';
import '../cubit/login/loginstate.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginType { pePhone, peEmail, workEmail }

class MyNumber extends StatefulWidget {
  const MyNumber({Key? key}) : super(key: key);

  @override
  State<MyNumber> createState() => _MyNumberState();
}

class _MyNumberState extends State<MyNumber> {
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
          content: Text(
            'Location services are disabled. Please enable the services.',
          ),
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
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
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
                            text: 'My Number is',
                            color: Color(0xff1B1B1B),
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 7),
                          AppText(
                            size: 17,
                            text:
                                'Don’t lose access to your account\nVerify your Phone Number.',
                            color: Color(0xff555555),
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: CountryCodePicker(
                                    onChanged: (countryCode) {
                                      setState(() {
                                        showFlag =
                                            countryCode.toString().length <= 2;
                                        codeController.text =
                                            countryCode.dialCode!;
                                        countryCodee = countryCode.dialCode!;
                                      });
                                    },
                                    initialSelection: 'US',
                                    favorite: ['+1', 'US'],
                                    showCountryOnly: false,
                                    backgroundColor: AppColor.darkmainColor,
                                    showOnlyCountryWhenClosed: false,
                                    showFlag: showFlag,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: showFlag ? 16 : 18,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFieldWidget(
                                  onchangevalue: (value) =>
                                      context.read<LogInCubit>().phone(value),
                                  controller: numberController,
                                  textFieldBorderColor: Colors.grey,
                                  textInputType: TextInputType.number,
                                  hint: 'Phone Number',
                                  hintColor: Colors.black,
                                  textFieldTitleColor: Colors.black,
                                  title: '',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                LoginType? loginType = determineLoginType();

                                if (numberController.text.trim().isNotEmpty &&
                                    emailController.text.trim().isNotEmpty &&
                                    workEmailController.text
                                        .trim()
                                        .isNotEmpty) {
                                  showToast(
                                    context,
                                    'Please select only one login credential.',
                                  );
                                  return;
                                }

                                if ((numberController.text.trim().isNotEmpty &&
                                        emailController.text
                                            .trim()
                                            .isNotEmpty) ||
                                    (numberController.text.trim().isNotEmpty &&
                                        workEmailController.text
                                            .trim()
                                            .isNotEmpty) ||
                                    (emailController.text.trim().isNotEmpty &&
                                        workEmailController.text
                                            .trim()
                                            .isNotEmpty)) {
                                  showToast(
                                    context,
                                    'Please select only one login credential.',
                                  );
                                  return;
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
                                        _deviceToken.toString(),
                                      );
                                      break;
                                    case LoginType.peEmail:
                                      context.read<LogInCubit>().email(
                                        context,
                                        "",
                                        emailController.text.trim(),
                                        lat,
                                        long,
                                        _deviceToken.toString(),
                                      );
                                      break;
                                    case LoginType.workEmail:
                                      context.read<LogInCubit>().email(
                                        context,
                                        "",
                                        workEmailController.text.trim(),
                                        lat,
                                        long,
                                        _deviceToken.toString(),
                                      );
                                      break;
                                  }
                                } else {
                                  showToast(
                                    context,
                                    'Please fill only one field.',
                                  );
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
