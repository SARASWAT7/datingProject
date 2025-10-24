import 'package:demoproject/component/apihelper/urls.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/getquestionresponse.dart';

class Questionsrepository{
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<GetQuestionsResponse> getQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response =
      await dio.get(UrlEndpoints.getquestion);
      return GetQuestionsResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw e.response!.data.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> answerQuestion(
      String questionId, List answer, String comment, String mainAnswer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(UrlEndpoints.answers, data: {
        "question_id": questionId,
        "answer": answer.join(","),
        "comment": comment
      });
      return response.data['message'];
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }


  Future<GetQuestionsResponse> getQuestionRemaning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response =
      await dio.get(UrlEndpoints.RemaningQuestion);
      return GetQuestionsResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw e.response!.data.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> answerQuestionRemaning(
      String questionId, List answer, String comment, String mainAnswer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(UrlEndpoints.answers, data: {
        "question_id": questionId,
        "answer": answer.join(","),
        "comment": comment
      });
      return response.data['message'];
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

}