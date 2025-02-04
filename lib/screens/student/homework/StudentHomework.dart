// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:edus_tutor/controller/user_controller.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/StudentRecordWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentHomework.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:edus_tutor/utils/widget/Homework_row.dart';

// ignore: must_be_immutable
class StudentHomework extends StatefulWidget {
  String? id;

  StudentHomework({super.key, this.id});

  @override
  _StudentHomeworkState createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework> {
  final UserController _userController = Get.put(UserController());
  Future<HomeworkList>? homeworks;
  String? _token;
  String? _id;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records?.first ?? Record();
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    Utils.getStringValue('id').then((idValue) {
      setState(() {
        _id = idValue;
        print(_id);
        homeworks = fetchHomework(
          widget.id != null
              ? int.parse(widget.id ?? '')
              : int.parse(idValue ?? ''),
          _userController.studentRecord.value.records?.first.id ?? 0,
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homeworks'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentRecordWidget(
              onTap: (Record record) async {
                _userController.selectedRecord.value = record;
                setState(
                  () {
                    homeworks = fetchHomework(
                        widget.id != null
                            ? int.parse(widget.id ?? '')
                            : int.parse(_id ?? ''),
                        record.id ?? 0);
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<HomeworkList>(
                future: homeworks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.homeworks.isNotEmpty) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: snapshot.data?.homeworks.length ?? 0,
                          itemBuilder: (context, index) {
                            return StudentHomeworkRow(
                                snapshot.data?.homeworks[index] ?? Homework(),
                                'student');
                          },
                        );
                      } else {
                        return Utils.noDataWidget(
                            text:
                                'There are no new homework at this time. Please use this opportunity to review and reinforce your understanding of previous lessons.');
                      }
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<HomeworkList> fetchHomework(int userId, recordId) async {
    final response = await http.get(
        Uri.parse(EdusApi.getStudenthomeWorksUrl(userId, recordId)),
        headers: Utils.setHeader(_token.toString()));
    log(response.request?.url.path ?? '');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return HomeworkList.fromJson(jsonData['data']);
    } else {
      throw Exception('failed to load');
    }
  }
}
