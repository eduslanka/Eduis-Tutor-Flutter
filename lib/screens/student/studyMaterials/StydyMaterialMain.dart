// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:edus_tutor/controller/user_controller.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/StudentRecordWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:edus_tutor/utils/model/UploadedContent.dart';
import 'package:edus_tutor/utils/widget/StudyMaterial_row.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class StudentStudyMaterialMain extends StatefulWidget {
  String? id;
  String? type;

  StudentStudyMaterialMain({super.key, this.id, this.type});

  @override
  _StudentStudyMaterialMainState createState() =>
      _StudentStudyMaterialMainState();
}

class _StudentStudyMaterialMainState extends State<StudentStudyMaterialMain> {
  final UserController _userController = Get.put(UserController());
  Future<UploadedContentList>? assignments;
  String? _token;
  String? _id;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    Utils.getStringValue('id').then((idValue) {
      setState(() {
        _id = idValue;
        assignments = fetchAssignment(
            widget.id != null
                ? int.parse(widget.id ?? '')
                : int.parse(idValue ?? ''),
            _userController.studentRecord.value.records?.first.id ?? 0,
            widget.type ?? '');
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
      appBar: CustomAppBarWidget(
          title: widget.type == "as"
              ? 'Assignment'.tr
              : widget.type == "sy"
                  ? "Syllabus".tr
                  : "Other Downloads".tr),
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
                setState(() {
                  assignments = fetchAssignment(
                      widget.id != null
                          ? int.parse(widget.id ?? '')
                          : int.parse(_id ?? ''),
                      record.id ?? 0,
                      widget.type ?? '');
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<UploadedContentList>(
                future: assignments,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.uploadedContents.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data?.uploadedContents.length ?? 0,
                        itemBuilder: (context, index) {
                          return StudyMaterialListRow(
                              snapshot.data?.uploadedContents[index] ??
                                  UploadedContent());
                        },
                      );
                    } else {
                      return Utils.noDataWidget(
                          text: widget.type == "as"
                              ? 'There are no new assignments scheduled for this period. Please use this time to complete any outstanding work or review previous materials'
                              : widget.type == "sy"
                                  ? 'The syllabus for this course is currently being updated. Please check back soon for the latest information and materials.'
                                  : 'There are currently no files available for download. Please check back later for any updates.');
                    }
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UploadedContentList> fetchAssignment(
      dynamic id, int recordId, String type) async {
    String url;

    if (type == 'as') {
      url = EdusApi.getStudentAssignment(id, recordId);
    } else if (type == 'sy') {
      url = EdusApi.getStudentSyllabus(id, recordId);
    } else {
      url = EdusApi.getStudentOtherDownloads(id, recordId);
    }

    final response = await http.get(Uri.parse(url),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('$url ====>>> ${jsonData['data']['uploadContents']}');
      return UploadedContentList.fromJson(jsonData['data']['uploadContents']);
    } else {
      throw Exception('failed to load');
    }
  }
}
