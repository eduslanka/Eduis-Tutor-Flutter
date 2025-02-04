import 'dart:convert';

import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/student_user_model.dart';

import '../model/fee_invoice_model.dart';
import '../model/quets_model.dart';
import 'package:http/http.dart' as http;

import '../utils/Utils.dart';

Future<Quote> fetchQuoteOfTheDay() async {
  final response = await http
      .get(Uri.parse('http://thurukural.edustutor.com/quote-of-the-day'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return Quote.fromMap(data);
  } else {
    throw Exception('Failed to load quote of the day');
  }
}

Future<ClassRecord> fetchStudentFees(int studentId) async {
  final url = EdusApi.getFeeApi(studentId);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return ClassRecord.fromJson(data);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<bool> isAllowTheUser() async {
  try {
    final email = await Utils.getStringValue('email');
    final password = await Utils.getStringValue('password');
    final response = await http.post(
      Uri.parse(EdusApi.login),
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.body);
    final user = StudentModel.fromJson(jsonDecode(response.body));

    return user.user.activeStatus == 1 || user.studentHaveDueFees == false;
  } catch (e, t) {
    print(e);
    print(t);

    return false;
  }
}
// Future<TodayClassResponse> fetchTodayClasses(String token) async {
//   try {
//     final response = await http.get(
//       Uri.parse(EdusApi.todayClass),
//       headers: Utils.setHeader(token),
//     );
//     print(EdusApi.todayClass);

//     if (response.statusCode == 200) {
//       return TodayClassResponse.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load today classes: ${response.body} ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Failed to load today classes: $e');
//   }
// }
