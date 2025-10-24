import 'dart:convert';
import 'dart:developer';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/alert_box.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../match/cubit/getuserbyidcubit.dart';
import '../../../match/cubit/getuserbyidstate.dart';
import '../../chat/design/chatroom.dart';


class MatchScreen1 extends StatefulWidget {
  final String userId;

  const MatchScreen1({
    super.key,
    required this.userId,
  });

  @override
  State<MatchScreen1> createState() => _MatchScreen1State();
}

class _MatchScreen1State extends State<MatchScreen1> {
  String userId = "";
  String userimage = "";
  String username = "";

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString("chatToken");
    log("asdfghjk==================>");
    print("userToken$userToken");
    var jsondata = json.decode(userToken!);

    setState(() {
      userimage = jsondata['profilePic'].toString();
      print("hvdkasvc,$userId");
      userId = jsondata['userID'].toString();
      username = jsondata['name'].toString();
    });
  }

  @override
  void initState() {
    getToken();
    Helper.executeWithConnectivityCheck(
      context,
      () async {
        BlocProvider.of<GetUserByIdCubit>(context).getUserById(widget.userId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetUserByIdCubit, GetUserByIdState>(
        listener: (context, state) {
          if (state is GetUserByIdSuccess) {
            if (state.homeResponse.result!.media!.isEmpty ||
                state.homeResponse.result == null) {
              Navigator.of(context).pop();
              showToast(context, "No data available. Profile not completed");
            }
          }
        },
        builder: (context, state) {
          if (state is GetUserByIdSuccess) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('assets/images/bgpattern.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Center(
                      child: Image.asset(
                    'assets/images/itsmatch.png',
                    width: 135,
                    height: 40,
                  )),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'You and ${state.homeResponse.result?.firstName ?? ''} have liked each other',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      softWrap: true, // Allows text to wrap to the next line
                      overflow: TextOverflow.visible, // Ensures text doesn't overflow
                    )

                  ),
                  SizedBox(height: 30),
                  Center(
                    child:
                    Container(
                      width: 300,
                      height: 300,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: ClipOval(
                              child: Image.network(
                                state.homeResponse.result?.profilePicture ?? "",
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover, // Ensures the image fits well in the circle
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: ClipOval(
                              child: Image.network(
                                userimage,
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover, // Ensures the image fits well in the circle
                              ),
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              'assets/images/like1.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ],
                      ),
                    )

                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: GestureDetector(
                          onTap: () {
                            // getToken();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      otherUserId: state.homeResponse.result!.firebaseId.toString(),
                                          userId: userId,
                                          profileImage: state.homeResponse.result!.profilePicture ?? "",
                                          userName: state.homeResponse.result!.firstName ?? "",
                                          pageNavId: 1,
                                          myImage: userimage,
                                          name: username,
                                        )));
                          },
                          child: CustomButton(text: 'Start Chat'))),
                  SizedBox(height: 15),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const BottomBar(currentIndex:0)),
                          );
                        },
                        child: CustomText(
                          size: 16,
                          text: 'Keep scrolling',
                          color: Colors.black,
                          weight: FontWeight.w700,
                          fontFamily: 'Nunito Sans',
                        )),
                  )

                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
