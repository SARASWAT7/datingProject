import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demoproject/ui/quesition/model/getquestionresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../component/reuseable_widgets/bottomTabBar.dart';
import '../../component/utils/custom_text.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/headerwidget.dart';
import 'cubit/answerquestion/answercubit.dart';
import 'cubit/getquestion/getquestiionstate.dart';
import 'cubit/getquestion/getquestioncubit.dart';
import 'package:sizer/sizer.dart';

class RemaningQues extends StatefulWidget {
  const RemaningQues({Key? key}) : super(key: key);

  @override
  State<RemaningQues> createState() => _RemaningQuesState();
}

class _RemaningQuesState extends State<RemaningQues> {
  late GetQuestionCubit _cubit;
  late AnswerCubit _answerCubit;
  int _currentQuestionIndex = 0;
  List<Result> _questions = [];
  int? _selectedCheckboxIndex;
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
    _cubit.getQuestionRemaning();
  }

  Future<void> _handleNextQuestion() async {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedCheckboxIndex = null;
        _commentController.clear();
      });
    } else {
      SharedPreferences pref=await SharedPreferences.getInstance();
      pref.setBool("GetStart", true);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomBar(
          currentIndex: 2,
        )
        ),

            (Route<dynamic> route) => false,
      );
    }
  }

  void _submitAnswer() async {
    final question = _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
    if (_selectedCheckboxIndex != null && question != null) {
      // Filter valid options (same logic as in _buildOptions)
      final validOptions = question.options?.where((option) => 
        option != null && 
        option.trim().isNotEmpty && 
        option != ' ' && 
        option != ''
      ).toList() ?? [];
      
      if (_selectedCheckboxIndex! < validOptions.length) {
        String selectedAnswer = validOptions[_selectedCheckboxIndex!];
        String comment = _commentController.text.trim();

        if (question.id != null && selectedAnswer.isNotEmpty) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid question or answer.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid selection.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an answer and add a comment.')),
      );
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
          if (question != null) _buildOptions(question) else Container(),
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
    // Filter out empty or null options from backend
    final validOptions = question.options?.where((option) => 
      option != null && 
      option.trim().isNotEmpty && 
      option != ' ' && 
      option != ''
    ).toList() ?? [];

    // If no valid options, don't show anything
    if (validOptions.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomText(
            size: 18,
            text: 'Please Select Your Answer.',
            color: Colors.black,
            weight: FontWeight.w600,
            fontFamily: 'Nunito Sans',
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < validOptions.length; i++)
              CheckboxListTile(
                title: Text(
                  validOptions[i],
                  style: TextStyle(
                    color: _selectedCheckboxIndex == i ? Colors.red : Colors.black,
                  ),
                ),
                value: _selectedCheckboxIndex == i,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedCheckboxIndex = i;
                    } else {
                      _selectedCheckboxIndex = null;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.red,
                checkColor: Colors.white,
              ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
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
        ),
      ],
    );
  }
}
