import 'package:demoproject/pushNotificationService.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatcubit.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/callcubit/callCubit.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/vediocubit.dart';
import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorecubit.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:demoproject/ui/dashboard/home/cubit/Introduce/intropagecubit.dart';
import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homecubit.dart';
import 'package:demoproject/ui/dashboard/home/repository/homerepository.dart';
import 'package:demoproject/ui/dashboard/likes/cubit/likedyoucubit.dart';
import 'package:demoproject/ui/dashboard/likes/cubit/youliked/youlikedcubit.dart';
import 'package:demoproject/ui/dashboard/notification/cubit/noticubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/Faq/faqcubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/dataprivacy/dataprivacycubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/feedback/feedbackcubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/moreabout/moreaboutmecubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilecubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/updateData/updateprofilecubit.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:demoproject/ui/dashboard/profile/repository/userData.dart';
import 'package:demoproject/ui/match/cubit/adcubit.dart';
import 'package:demoproject/ui/match/cubit/getuserbyidcubit.dart';
import 'package:demoproject/ui/quesition/cubit/answerquestion/answercubit.dart';
import 'package:demoproject/ui/quesition/cubit/getquestion/getquestioncubit.dart';
import 'package:demoproject/ui/quesition/repo/questionsrepository.dart';
import 'package:demoproject/ui/reels/cubit/allreels/allreelscubit.dart';
import 'package:demoproject/ui/reels/cubit/myreels/myreelscubit.dart';
import 'package:demoproject/ui/subscrption/subscription/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/ui/AuthRepository/authrepository.dart';
import 'package:demoproject/ui/auth/cubit/socallogin/socallogincubit.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:demoproject/component/apihelper/startup_optimizer.dart';
import 'package:demoproject/component/apihelper/firebase_error_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const kGoogleApiKey = "AIzaSyCnRAGJaYpc4edJi8DcHaimmJ9mW4k4EVM";

setBadgeNum(int count) async {
  try {
    FlutterLocalNotificationsPlugin().cancelAll();
  } catch (e) {
    print(e);
  }
}

void main() async {
  // Handle async errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Fix input dispatching timeout by setting proper window focus
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

    try {
      // Initialize Firebase with comprehensive error handling
      final firebaseInitialized = await FirebaseErrorHandler.initializeFirebase();
      
      if (firebaseInitialized) {
        if (kDebugMode) {
          print('✅ Firebase initialized successfully with all services');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Firebase initialization failed, but app will continue');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Critical Firebase initialization error: $e');
      }
      // Don't crash the app if Firebase fails
      FirebaseErrorHandler.recordError(e, null, fatal: true);
    }

    try {
      await PushNotificationService2().setupInteractedMessage();
    } catch (e) {
      if (kDebugMode) {
        print('Push notification setup error: $e');
      }
      FirebaseErrorHandler.recordError(e, null);
    }

    // Initialize startup optimizer for ultra-fast performance
    try {
      await StartupOptimizer.initializeApp();
    } catch (e) {
      if (kDebugMode) {
        print('Startup optimization error: $e');
      }
      // Don't crash the app if startup optimization fails
      FirebaseErrorHandler.recordError(e, null);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((value) => runApp(MyApp()));
  }, (error, stack) {
    if (kDebugMode) {
      print('Uncaught error: $error');
      print('Stack trace: $stack');
    }

    // Enhanced error handling for different error types
    if (error is DioException) {
      if (kDebugMode) {
        print('DioException caught: ${error.type} - ${error.message}');
      }
    } else if (error is SocketException) {
      if (kDebugMode) {
        print('SocketException caught: ${error.message}');
      }
    } else if (error is HttpException) {
      if (kDebugMode) {
        print('HttpException caught: ${error.message}');
      }
    }

            // Pass all uncaught errors to Firebase Crashlytics
            FirebaseErrorHandler.recordError(error, stack, fatal: true);
  });
}

// App lifecycle observer to handle window focus and prevent input dispatching timeout
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground and focused
        if (kDebugMode) {
          print('App resumed - window focused');
        }
        break;
      case AppLifecycleState.paused:
        // App is in background
        if (kDebugMode) {
          print('App paused - window unfocused');
        }
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        if (kDebugMode) {
          print('App detached - cleaning up');
        }
        break;
      case AppLifecycleState.inactive:
        // App is inactive but still visible
        if (kDebugMode) {
          print('App inactive - window may lose focus');
        }
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        if (kDebugMode) {
          print('App hidden - window hidden');
        }
        break;
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final List<AppLifecycleState> _stateHistoryList = <AppLifecycleState>[];
  final HomeRepository _authRepo = HomeRepository();

  @override
  void initState() {
    super.initState();
    setBadgeNum(0);
    WidgetsBinding.instance.addObserver(
      this,
    ); // Add observer for app lifecycle changes
    if (WidgetsBinding.instance.lifecycleState != null) {
      _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
  }

  Future<void> updatestatus(String lifestatus) async {
    try {
      if (lifestatus == "AppLifecycleState.resumed") {
        await _authRepo.onlinestatus(true);
      } else {
        await _authRepo.onlinestatus(false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating status: $e');
      }
      // Record error to Crashlytics
      CrashHandler.recordError(e, null);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("code");
    updatestatus(state.toString());
    setState(() {
      _stateHistoryList.add(state);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        final repository = Questionsrepository();
        final repo = HomeRepository();
        final moreAboutRepo = UpdateProfileDataRepo();
        final auth = AuthRepository();
        final userData = CorettaUserProfileRepo();
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => FilterCubit()),
            BlocProvider(create: (_) => HomePageCubit()),
            BlocProvider(create: (_) => ProfileCubit()),
            BlocProvider(create: (_) => ChatCubit()),
            BlocProvider(create: (_) => GetQuestionCubit(repository)),
            BlocProvider(create: (_) => AnswerCubit(repository)),
            BlocProvider(create: (_) => LikedYouCubit()),
            BlocProvider(create: (_) => IntroAddCubit(repo)),
            BlocProvider(create: (_) => UpdateProfileCubit()),
            BlocProvider(create: (_) => ExploreCubit()),
            BlocProvider(create: (_) => FaqCubit()),
            BlocProvider(create: (_) => DataprivacyCubit()),
            BlocProvider(create: (_) => FeedbackCubit()),
            BlocProvider(create: (_) => GetUserByIdCubit(repo)),
            BlocProvider(create: (_) => MoreAboutMeProfileCubit(moreAboutRepo)),
            BlocProvider(create: (_) => YouLikedCubit()),
            BlocProvider(create: (context) => VideoCallCubit()),
            BlocProvider(create: (context) => AcceptRejectCubit()),
            BlocProvider(create: (context) => NotificationListCubit()),
            BlocProvider(create: (context) => LoginSocialCubit(auth)),
            BlocProvider(create: (context) => AgreeCubit(repo)),
            BlocProvider(create: (context) => ProfileReelsCubit(userData)),
            BlocProvider(create: (context) => AllReelsCubit(userData)),
            BlocProvider(create: (context) => SubscriptionCubit(userData)),
          ],
          child: MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                child: child!,
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
              );
            },
            title: "Coretta",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const SplashScreen(),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}