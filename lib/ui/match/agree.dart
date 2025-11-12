import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/appBar.dart';
import '../../component/reuseable_widgets/customNavigator.dart';
import '../../component/utils/custom_text.dart';
import '../quesition/remaningQuestions.dart';
import 'cubit/adcubit.dart';
import 'cubit/adstate.dart';

class AgreeScreen extends StatefulWidget {
  final String UserName;
  final String UserImg;
  final String userId;

   AgreeScreen( {Key? key,
     required this.UserName,
     required this.UserImg,
     required this.userId}) : super(key: key);

  @override
  State<AgreeScreen> createState() => _AgreeScreenState();
}

class _AgreeScreenState extends State<AgreeScreen> {
  String selectedOption = "AGREE";
  bool isCheckboxChecked = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely access context after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<AgreeCubit>(context).getAgreeDisagreeData(widget.userId);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgreeCubit, AgreeState>(
      builder: (context, state) {
        if (state is AgreeLoading) {
          return Center(child: AppLoader()); 
        } else if (state is AgreeFailure) {
          return Center(child: Text('Error: ${state.message}')); // Show error message
        } else if (state is AgreeSuccess) {
          return Scaffold(
            appBar:
            appBarWidgetThree(
              leading: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Transform.scale(
                    scale: 0.5,
                    child: Image.asset(
                      'assets/images/backarrow.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              title: 'You & ${widget.UserName}',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
              showBorder: false,
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color(0xffFFC8D3),
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(45),topRight:Radius.circular(45)),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(
                                state.agreeResponse.result?.profilePic ?? "",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Image.asset(
                              'assets/images/like1.png',
                              width: 50,
                              height: 50,
                            ),
                            ClipOval(
                              child: Image.network(
                                widget.UserImg,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = "AGREE";
                                });
                              },
                              child: buildOptionCard(
                                "AGREE",
                                'assets/images/bluelike.png',
                                state.agreeResponse.result?.agreeCount?.toString() ?? "0",
                                selectedOption == "AGREE",
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = "DISAGREE";
                                });
                              },
                              child: buildOptionCard(
                                "DISAGREE",
                                'assets/images/dislike.png',
                                state.agreeResponse.result?.disagreeCount?.toString() ?? "0",
                                selectedOption == "DISAGREE",
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = "FINDOUT";
                                });

                              },
                              child: buildOptionCard(
                                "FIND OUT",
                                'assets/images/find.png',
                                state.agreeResponse.result?.findOut?.toString() ?? "0",
                                selectedOption == "FINDOUT",
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 20),
                        if (selectedOption == "AGREE") ...[
                          // If selected option is AGREE, display the AGREE-related answers
                          if (state.agreeResponse.result?.agreeAnswer != null && state.agreeResponse.result!.agreeAnswer!.isNotEmpty)
                            for (var answer in state.agreeResponse.result!.agreeAnswer!)
                              buildQuestionContainer(
                                question: answer.matchedQuestion?.question ?? "Question not available",
                                yourAnswer: answer.userAnswer ?? "No answer",
                                friendAnswer: answer.matchUserAnswer ?? "No friend answer",
                                userImage: state.agreeResponse.result?.profilePic ?? "",
                                friendImage: widget.UserImg,
                              ),
                          if (state.agreeResponse.result?.agreeAnswer == null || state.agreeResponse.result!.agreeAnswer!.isEmpty)
                            Center(
                              heightFactor: 14,
                              child: CustomText(
                                size: 16,
                                text: "No Data Found for Agree",
                                color: Colors.black,
                                weight: FontWeight.w500,
                                fontFamily: 'Nunito Sans',
                              ),
                            ),
                        ] else if (selectedOption == "DISAGREE") ...[
                          if (state.agreeResponse.result?.disagreeAnswer != null && state.agreeResponse.result!.disagreeAnswer!.isNotEmpty)
                            for (var answer in state.agreeResponse.result!.disagreeAnswer!)
                              buildQuestionContainer(
                                question: answer.unmatchedQuestion?.question ?? "Question not available",
                                yourAnswer: answer.userAnswer ?? "No answer",
                                friendAnswer: answer.matchUserAnswer ?? "No friend answer",
                                userImage: state.agreeResponse.result?.profilePic ?? "",
                                friendImage: widget.UserImg,
                              ),
                          if (state.agreeResponse.result?.disagreeAnswer == null || state.agreeResponse.result!.disagreeAnswer!.isEmpty)
                            Center(
                              heightFactor: 14,
                              child: CustomText(
                                size: 16,
                                text: "No Data Found for Disagree",
                                color: Colors.black,
                                weight: FontWeight.w500,
                                fontFamily: 'Nunito Sans',
                              ),
                            ),
                        ] else if (selectedOption == "FINDOUT") ...[
                          buildFindWidget(state.agreeResponse.result?.findOut?.toString() ?? "0")
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(); // Return empty container if no state matches
      },
    );
  }



  Widget buildOptionCard(String title, String imagePath, String count, bool isSelected) {
    return Container(
      width: 92,
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColor.tinderclr : Colors.transparent, // Change border color based on selection
          width: 2, // Border width
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            size: 14,
            text: title,
            color: AppColor.tinderclr,
            weight: FontWeight.w700,
            fontFamily: 'Nunito Sans',
          ),
          SizedBox(height: 5),
          Image.asset(imagePath, width: 30, height: 30),
          SizedBox(height: 5),
          CustomText(
            size: 16,
            text: count,
            color: AppColor.tinderclr,
            weight: FontWeight.w700,
            fontFamily: 'Nunito Sans',
          ),
        ],
      ),
    );
  }

  Widget buildQuestionContainer({
    required String question,
    required String yourAnswer,
    required String friendAnswer,
    required String userImage, // User image URL
    required String friendImage, // Friend image URL
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16), // Add spacing between containers
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          CustomText(
            size: 16,
            text: question,
            color: Colors.black,
            weight: FontWeight.w700,
            fontFamily: 'Nunito Sans',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  userImage, // User's dynamic image
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              CustomText(
                size: 16,
                text: yourAnswer,
                color: Colors.black,
                weight: FontWeight.w600,
                fontFamily: 'NunitoSans',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  friendImage, // Friend's dynamic image
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              CustomText(
                size: 16,
                text: friendAnswer,
                color: Colors.black,
                weight: FontWeight.w600,
                fontFamily: 'NunitoSans',
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget buildDisagreeWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            size: 16,
            text: "How do you feel about having a joint bank account in a long-term relationship?",
            color: Colors.black,
            weight: FontWeight.w700,
            fontFamily: 'Nunito Sans',
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
              setState(() {
                isCheckboxChecked = true;
              });
            },
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: isCheckboxChecked,
                    onChanged: (value) {
                      setState(() {
                        isCheckboxChecked = value ?? false;
                      });
                    },
                    activeColor: AppColor.tinderclr,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: AppColor.tinderclr,
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    text: "I prefer Joint account",
                    size: 16,
                    color: Colors.black,
                    weight: FontWeight.w500,
                    fontFamily: 'Nunito Sans',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                isCheckboxChecked = false;
              });
            },
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: !isCheckboxChecked,
                    onChanged: (value) {
                      setState(() {
                        isCheckboxChecked = !(value ?? false);
                      });
                    },
                    activeColor: AppColor.tinderclr,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: AppColor.tinderclr,
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    text: "I prefer independent accounts",
                    size: 16,
                    color: Colors.black,
                    weight: FontWeight.w500,
                    fontFamily: 'Nunito Sans',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.edit,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFindWidget(String findOut) {
    bool isFindOutZero = findOut == "0";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Text: "You Answered All Of Their Questions"
          Center(
            child: CustomText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              size: 16,
              text: isFindOutZero
                  ? 'You Answered All Of Their Questions'
                  : 'Please fill remaining questions to continue',
              color: Colors.black,
              weight: FontWeight.w600,
              fontFamily: "Nunito Sans",
            ),
          ),
          SizedBox(height: 8.0),

          Center(
            child: Align(
              alignment: Alignment.center,
              child: CustomText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                size: 14,
                text: isFindOutZero
                    ? 'Give others something to find out by answering your own'
                    : 'Fill in the remaining questions to allow others to find out more about you.',
                color: Colors.black,
                weight: FontWeight.w500,
                fontFamily: "Nunito Sans",
              ),
            ),
          ),

          SizedBox(height: 16.0),

          // Show the "Fill Remaining Questions to Proceed" message only if findOut is not "0"
          if (!isFindOutZero)
            GestureDetector(
              onTap: () {
                CustomNavigator.push(context: context, screen: RemaningQues());
              },
              child: Center(
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  size: 20,
                  text: 'Fill Remaining Questions to Proceed',
                  color: AppColor.tinderclr,
                  weight: FontWeight.w500,
                  fontFamily: "Nunito Sans",
                ),
              ),
            ),
        ],
      ),
    );
  }


}

