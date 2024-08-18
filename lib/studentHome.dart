import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnpro_frontend/Cources.dart';
import 'package:learnpro_frontend/CoursePage.dart';
import 'package:learnpro_frontend/Login.dart';
import 'package:http/http.dart' as http;

class HomeStudent extends StatefulWidget {
  final String token;
  const HomeStudent({super.key, required this.token});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {

  Future<void> Logout() async{
    String result = '';
    final String apiurl = 'http://10.0.2.2:8000/api/v1/logout';

    try{
      final response = await http.post(
        Uri.parse(apiurl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if(response.statusCode == 200){
        Get.offAll(Login());
      }
    }catch(c){
      setState(() {
        result = 'Error: $c';
      });
    }
  }

  List<Course> cources = [];

  Future<void> GetCources() async {
    final String apiUrl = 'http://10.0.2.2:8000/api/v1/courses';

    try{

      final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          }
      );

      if(response.statusCode == 200){
        final List<dynamic> allcourses = jsonDecode(response.body);

        setState(() {
          cources = allcourses.map((json) => Course.fromJson(json)).toList();


        });
      }else{
        showDialog(context: context, builder:
        (context) => Text(response.body),);
      }

    }catch(e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text('Error Fetching Courses'),
          content: Text('$e'),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCources();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              children: [
                Text('LearnPro')
              ],
            ),
            Column(
               children: [
                 TextButton(onPressed: (){
                   Logout();
                 },
                     child: Text('Logout'),
                 )
               ],
            )
          ],
        )
      ),
      body: cources.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: cources.length,
            itemBuilder: (context, index) {
            final course = cources[index];
            return ListTile(
              title: Text(course.title),
              subtitle: Text(course.category),
              onTap: () {
                Get.to(CoursePage(courseId: course.id, token:widget.token));
              },
            );
          },
        ),
      );
    }
}
