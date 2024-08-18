import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:learnpro_frontend/Cources.dart';
import 'Login.dart';


class CoursePage extends StatefulWidget {
  final int courseId;
  final String token;
  const CoursePage({super.key, required this.courseId, required this.token});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Course courseData = Course(id: (0), instructorId: 0, title: '', category: '', description: '', createdAt: '', updatedAt: '');

  Future<void> Logout() async{
    String result = '';
    const String apiurl = 'http://10.0.2.2:8000/api/v1/logout';
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

  Future<void> fetchCourseDate() async{
    final String apiUrl = 'http://10.0.2.2:8000/api/v1/courses/${widget.courseId}';
    try{
      final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          }
      );
      if(response.statusCode == 200){
        final List<dynamic> fetchedData = jsonDecode(response.body);
        setState(() {
          courseData = Course.fromJson(fetchedData[0]);
        });
      }
    }catch(e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Error Fetching Courses'),
          content: Text('$e'),
        );
      });
    }
  }

  bool? isEnrolled;

  Future<void> checkEnrollmentStatus() async{
     final String apiUrl = 'http://10.0.2.2:8000/api/v1/courses/${widget.courseId}/checkEnrollment';
     try{
       final response = await http.get(
         Uri.parse(apiUrl),
         headers: {
           'Content-Type': 'application/json',
           'Authorization': 'Bearer ${widget.token}',
         }
       );

       if(response.statusCode == 200){
         setState(() {
            isEnrolled = jsonDecode(response.body);
         });

       }else{
         setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error Fetching Courses')),
            );
            setState(() {
              isEnrolled = false;
            });
         });
       }
     }catch(e){
       showDialog(context: context, builder: (context) {
         return AlertDialog(
           title: const Text('Error Fetching Courses'),
           content: Text('$e'),
         );
       });
     }
  }
  Future<void> Unenroll() async{
    final String apiUrl = 'http://10.0.2.2:8000/api/v1/courses/${widget.courseId}/unenroll';
    try{
      final response =await http.delete(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          }
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unenrolled successfully!')),
        );
        setState(() {
          isEnrolled = false;
        });
      }
    }catch(e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Error Unenrolling Courses'),
          content: Text('$e'),
        );
      });
    }
  }
  Future<void> Enroll() async{
    final String apiUrl = 'http://10.0.2.2:8000/api/v1/courses/${widget.courseId}/enroll';
    try{
      final response =await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          }
      );
      if (response.statusCode == 200) {
        setState(() {
          isEnrolled = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enrolled successfully!')),
        );
      }
    }catch(e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Error Enrolling Courses'),
          content: Text('$e'),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCourseDate();
    checkEnrollmentStatus();
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
              ),
            ],
          )
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text('Course: ${courseData.title}', style:const TextStyle(
                fontSize: 30.00,
              ),),
              Text('Category: ${courseData.category}' , style: const TextStyle(
                fontSize: 20.00,
              ),),
              Text(courseData.description,style: const TextStyle(
                fontSize: 20.00,
              ),),
              isEnrolled == null ? const CircularProgressIndicator() :
              isEnrolled! ? ElevatedButton(onPressed: () {
                Unenroll();
              }, child: const Text('Unenroll')) : ElevatedButton(onPressed: (){
                Enroll();
              }, child: const Text('Enroll')),

            ],
          ),
        ),
      ),

    );
  }
}
