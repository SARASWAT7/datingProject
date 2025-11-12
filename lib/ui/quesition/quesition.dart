import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demoproject/ui/quesition/model/getquestionresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../component/reuseable_widgets/bottomTabBar.dart';
import '../../component/utils/custom_text.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/headerwidget.dart';
import '../../component/reuseable_widgets/apploder.dart';
import 'cubit/answerquestion/answercubit.dart';
import 'cubit/getquestion/getquestiionstate.dart';
import 'cubit/getquestion/getquestioncubit.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';

class QuesitionsPage extends StatefulWidget {
  const QuesitionsPage({Key? key}) : super(key: key);

  @override
  State<QuesitionsPage> createState() => _QuesitionsPageState();
}

class _QuesitionsPageState extends State<QuesitionsPage> {
  late GetQuestionCubit _cubit;
  late AnswerCubit _answerCubit;
  int _currentQuestionIndex = 0;
  List<Result> _questions = [];
  int? _selectedCheckboxIndex;
  final GroupButtonController controller = GroupButtonController();
  final TextEditingController _commentController = TextEditingController();
  int? lettercount = 500;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GetQuestionCubit>(context);
    _answerCubit = BlocProvider.of<AnswerCubit>(context);
    _fetchQuestions();
  }

  void _fetchQuestions() {
    _cubit.getQuestion();
  }

  Future<void> _handleNextQuestion() async {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedCheckboxIndex = null;
        controller.unselectAll();
        _commentController.clear();
      });
    } else {
      SharedPreferences pref=await SharedPreferences.getInstance();
      pref.setBool("GetStart", true);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomBar()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _submitAnswer() async {
    final question = _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
    if (question == null || question.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid question.')),
      );
      return;
    }

    // Filter valid options (non-empty)
    final validOptions = <MapEntry<int, String>>[];
    if (question.options != null) {
      for (int i = 0; i < question.options!.length; i++) {
        final option = question.options![i];
        if (option.toString().trim().isNotEmpty) {
          validOptions.add(MapEntry(i, option.toString()));
        }
      }
    }
    
    final hasValidOptions = validOptions.isNotEmpty;
    final comment = _commentController.text.trim();

    // If question has valid options, require selection
    if (hasValidOptions) {
      if (_selectedCheckboxIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an answer.')),
        );
        return;
      }
      
      // Verify selected index is valid and get the answer
      final selectedEntry = validOptions.firstWhere(
        (entry) => entry.key == _selectedCheckboxIndex,
        orElse: () => MapEntry(-1, ''),
      );
      
      if (selectedEntry.key == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid selection.')),
        );
        return;
      }
      
      final selectedAnswer = selectedEntry.value;
      try {
        await _answerCubit.answerQuestion(
          question.id!,
          [selectedAnswer],
          comment,
          selectedAnswer,
        );
        _handleNextQuestion();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit answer: $e')),
        );
      }
    } else {
      // If no options, allow submission with just comment
      try {
        await _answerCubit.answerQuestion(
          question.id!,
          [],
          comment,
          comment.isNotEmpty ? comment : 'No answer selected',
        );
        _handleNextQuestion();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit answer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<GetQuestionCubit, GetQuestionState>(
            builder: (context, state) {
              if (state is GetQuestionLoadingState) {
                return AppLoader();
              } else if (state is GetQuestionSuccessState) {
                _questions = state.response.result ?? [];
                if (_questions.isEmpty) {
                  return Center(child: Text('No questions available.'));
                }
                return _buildQuestionContent();
              } else if (state is GetQuestionErrorState) {
                return Center(child: Text('Failed to load questions.'));
              }
              return Center(child: Text('Loading...'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    final question = _questions[_currentQuestionIndex];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(
            title: '${_currentQuestionIndex + 1}/${_questions.length}',
            progress: (_currentQuestionIndex + 1) / _questions.length,
            onTap: () {},
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomText(
              size: 20,
              text: question.question ?? 'Loading...',
              color: Colors.black,
              weight: FontWeight.w600,
              fontFamily: 'Nunito Sans',
            ),
          ),
          SizedBox(height: 10),
          _buildOptions(question),
          SizedBox(height: 50),
          Center(
            child: CustomButton(
              text: 'Continue',
              onPressed: _submitAnswer,
            ),
          ),
          SizedBox(height: 14),
          Center(
            child: TextButton(
              onPressed: _handleNextQuestion,
              child: CustomText(
                text: 'SKIP TO NEXT',
                size: 16,
                color: Colors.black,
                weight: FontWeight.w700,
                fontFamily: 'Nunito Sans',
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildOptions(Result question) {
    // Filter out empty/null options and get valid options with their original indices
    final validOptions = <MapEntry<int, String>>[];
    if (question.options != null) {
      for (int i = 0; i < question.options!.length; i++) {
        final option = question.options![i];
        if (option.toString().trim().isNotEmpty) {
          validOptions.add(MapEntry(i, option.toString()));
        }
      }
    }
    
    final hasValidOptions = validOptions.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show checkbox section if valid options exist
        if (hasValidOptions) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomText(
              size: 18,
              text: 'Please Select Your Answer.',
              color: Colors.black,
              weight: FontWeight.w400,
              fontFamily: 'Nunito Sans',
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Only render checkboxes for valid (non-empty) options
              for (var entry in validOptions)
                CheckboxListTile(
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      color:
                          _selectedCheckboxIndex == entry.key ? Colors.red : Colors.black,
                    ),
                  ),
                  value: _selectedCheckboxIndex == entry.key,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCheckboxIndex = entry.key;
                        controller.selectIndex(entry.key); // Synchronize with GroupButton
                      } else {
                        _selectedCheckboxIndex = null;
                        controller.unselectAll();
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                ),
            ],
          ),
        ],
        // Always show comment field
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: hasValidOptions ? 0 : 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffBDBDBD)),
                color: Colors.transparent),
            child: TextField(
              controller: _commentController,
              onChanged: (value) {
                setState(() {
                  lettercount = 500 - value.length;
                });
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Your Opinion...'),
              maxLines: 6,
            ).pOnly(left: 2.3.w, right: 2.3.w),
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:demoproject/ui/quesition/model/getquestionresponse.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../component/commonfiles/appcolor.dart';
// import '../../component/reuseable_widgets/bottomTabBar.dart';
// import '../../component/utils/custom_text.dart';
// import '../../component/reuseable_widgets/custom_button.dart';
// import '../../component/utils/headerwidget.dart';
// import 'cubit/answerquestion/answercubit.dart';
// import 'cubit/getquestion/getquestiionstate.dart';
// import 'cubit/getquestion/getquestioncubit.dart';
// import 'package:group_button/group_button.dart';
// import 'package:sizer/sizer.dart';
//
// class QuesitionsPage extends StatefulWidget {
//   const QuesitionsPage({Key? key}) : super(key: key);
//
//   @override
//   State<QuesitionsPage> createState() => _QuesitionsPageState();
// }
//
// class _QuesitionsPageState extends State<QuesitionsPage> {
//   late GetQuestionCubit _cubit;
//   late AnswerCubit _answerCubit;
//   int _currentQuestionIndex = 0;
//   List<Result> _questions = [];
//   int? _selectedCheckboxIndex;
//   final GroupButtonController controller = GroupButtonController();
//   final TextEditingController _commentController = TextEditingController();
//   int lettercount = 500;
//
//   @override
//   void initState() {
//     super.initState();
//     _cubit = BlocProvider.of<GetQuestionCubit>(context);
//     _answerCubit = BlocProvider.of<AnswerCubit>(context);
//     _fetchQuestions();
//   }
//
//   void _fetchQuestions() {
//     _cubit.getQuestion();
//   }
//
//   Future<void> _handleNextQuestion() async {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//         _selectedCheckboxIndex = null;
//         controller.unselectAll();
//         _commentController.clear();
//       });
//     } else {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       pref.setBool("GetStart", true);
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => BottomBar()),
//       );
//     }
//   }
//
//   Future<void> _handlePreviousQuestion() async {
//     if (_currentQuestionIndex > 0) {
//       setState(() {
//         _currentQuestionIndex--;
//         _selectedCheckboxIndex = null;
//         controller.unselectAll();
//         _commentController.clear();
//       });
//     } else {
//       Navigator.of(context).pop(); // Go back to the start page or previous screen
//     }
//   }
//
//   void _submitAnswer() async {
//     final question = _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
//     if (_selectedCheckboxIndex != null && question != null) {
//       String selectedAnswer = question.options![_selectedCheckboxIndex!];
//       String comment = _commentController.text.trim();
//
//       if (question.id != null && selectedAnswer.isNotEmpty) {
//         try {
//           await _answerCubit.answerQuestion(
//             question.id!,
//             [selectedAnswer],
//             comment,
//             selectedAnswer,
//           );
//           _handleNextQuestion();
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to submit answer: $e')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Invalid question or answer.')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an answer and add a comment.')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentQuestionIndex > 0) {
//           _handlePreviousQuestion(); // Go back to the previous question
//           return false; // Prevent default pop behavior
//         } else {
//           Navigator.of(context).pop(); // Go back to the start page or previous screen
//           return true; // Allow the default pop behavior
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: BlocBuilder<GetQuestionCubit, GetQuestionState>(
//             builder: (context, state) {
//               if (state is GetQuestionLoadingState) {
//                 return AppLoader();
//               } else if (state is GetQuestionSuccessState) {
//                 _questions = state.response.result ?? [];
//                 if (_questions.isEmpty) {
//                   return Center(child: Text('No questions available.'));
//                 }
//                 return _buildQuestionContent();
//               } else if (state is GetQuestionErrorState) {
//                 return Center(child: Text('Failed to load questions.'));
//               }
//               return Center(child: Text('Loading...'));
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestionContent() {
//     final question = _questions[_currentQuestionIndex];
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderWidget(
//             title: '${_currentQuestionIndex + 1}/${_questions.length}',
//             progress: (_currentQuestionIndex + 1) / _questions.length,
//             onTap: () {},
//           ),
//           SizedBox(height: 15),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: CustomText(
//               size: 20,
//               text: question.question ?? 'Loading...',
//               color: Colors.black,
//               weight: FontWeight.w600,
//               fontFamily: 'Nunito Sans',
//             ),
//           ),
//           SizedBox(height: 10),
//           if (question != null) _buildOptions(question) else Container(),
//           SizedBox(height: 50),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CustomButton(
//                   text: 'Previous',
//                   onPressed: _handlePreviousQuestion, // Handle previous question
//                 ),
//                 CustomButton(
//                   text: 'Continue',
//                   onPressed: _submitAnswer,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 14),
//           Center(
//             child: TextButton(
//               onPressed: _handleNextQuestion,
//               child: CustomText(
//                 text: 'SKIP TO NEXT',
//                 size: 16,
//                 color: Colors.black,
//                 weight: FontWeight.w700,
//                 fontFamily: 'Nunito Sans',
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOptions(Result question) {
//     if (question.options == null || question.options!.isEmpty)
//       return Container();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: GroupButton(
//             controller: controller,
//             isRadio: true,
//             maxSelected: 1,
//             buttons: question.options!,
//             onSelected: (value, index, isSelected) {
//               setState(() {
//                 _selectedCheckboxIndex = index;
//               });
//             },
//             options: GroupButtonOptions(
//               selectedShadow: [],
//               selectedTextStyle: TextStyle(
//                 fontSize: 18.sp,
//                 color: Colors.red,
//               ),
//               selectedColor: Colors.transparent,
//               selectedBorderColor: bgClr,
//               unselectedBorderColor: null,
//               borderRadius: BorderRadius.circular(30),
//               unselectedColor: Colors.transparent,
//               spacing: 1.h,
//               runSpacing: 1.h,
//               groupingType: GroupingType.column,
//               direction: Axis.horizontal,
//               buttonHeight: 6.h,
//               buttonWidth: 45.w,
//               mainGroupAlignment: MainGroupAlignment.start,
//               crossGroupAlignment: CrossGroupAlignment.start,
//               groupRunAlignment: GroupRunAlignment.start,
//               textAlign: TextAlign.center,
//               textPadding: EdgeInsets.zero,
//               alignment: Alignment.center,
//               elevation: 0,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: CustomText(
//             size: 18,
//             text: 'Answer you’ll accept?',
//             color: Colors.black,
//             weight: FontWeight.w600,
//             fontFamily: 'Nunito Sans',
//           ),
//         ),
//         const SizedBox(height: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             for (int i = 0; i < question.options!.length; i++)
//               CheckboxListTile(
//                 title: Text(
//                   question.options![i],
//                   style: TextStyle(
//                     color: _selectedCheckboxIndex == i ? Colors.red : Colors.black,
//                   ),
//                 ),
//                 value: _selectedCheckboxIndex == i,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       _selectedCheckboxIndex = i;
//                       controller.selectIndex(i); // Synchronize with GroupButton
//                     } else {
//                       _selectedCheckboxIndex = null;
//                       controller.unselectAll();
//                     }
//                   });
//                 },
//                 controlAffinity: ListTileControlAffinity.leading,
//                 activeColor: Colors.red,
//                 checkColor: Colors.white,
//               ),
//             Padding(
//               padding: const EdgeInsets.only(left: 24, right: 24),
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: const Color(0xffBDBDBD)),
//                     color: Colors.transparent),
//                 child: TextField(
//                   controller: _commentController,
//                   onChanged: (value) {
//                     setState(() {
//                       lettercount = 500 - value.length;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Add Your Opinion...'),
//                   maxLines: 6,
//                 ).pOnly(left: 2.3.w, right: 2.3.w),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
