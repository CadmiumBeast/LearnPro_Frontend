import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:learnpro_frontend/instructorHome.dart';

import 'Login.dart';

class Addcource extends StatefulWidget {
  final String token;
  const Addcource({super.key, required this.token});

  @override
  State<Addcource> createState() => _AddcourceState();
}

class _AddcourceState extends State<Addcource> {

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
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> AddCource() async{
    String title = titleController.text;
    String category = categoryController.text;
    String description = descriptionController.text;

    Map<String, dynamic> userInput = {
      'title' : title,
      'category' : category,
      'description' : description
    };

    String NewCourse = jsonEncode(userInput);

    String result = '';
    final String apiurl = 'http://10.0.2.2:8000/api/v1/courses';
    try{
        final response = http.post(
          Uri.parse(apiurl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: NewCourse
        );
        Get.offAll(HomeInstructor(token: widget.token));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text('LearnPro'),
                  Text('Instructor' , style: TextStyle(fontSize: 10),),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.00, horizontal: 15.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Add Course'),
                SizedBox(
                  height: 30.00,
                ),
                Text('Course Name'),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.00)),
                      )
                  ),
                ),
                Text('Course Category'),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.00)),
                      )
                  ),
                ),
                Text('Course Description'),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.00)),
                      )
                  ),
                ),
                SizedBox(
                  height: 20.00,
                ),
                ElevatedButton(onPressed: () {
                  AddCource();
                }, child: Text('Add Course'))
              ],
            ),
          ),
        ),
      ),


    );
  }
}
