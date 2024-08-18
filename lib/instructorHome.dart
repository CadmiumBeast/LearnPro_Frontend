import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnpro_frontend/AddCource.dart';

import 'Cources.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class HomeInstructor extends StatefulWidget {
  final String token;
  const HomeInstructor({super.key, required this.token});

  @override
  State<HomeInstructor> createState() => _HomeInstructorState();
}

class _HomeInstructorState extends State<HomeInstructor> {

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
        child: Column(
          children: [
            Expanded(
              child: cources.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: cources.length,
                    itemBuilder: (context, index) {
                    final course = cources[index];
                    return ListTile(
                      title: Text(course.title),
                      subtitle: Text(course.category),
                    onTap: () {
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => Addcource(token: widget.token));

                },
                child: const Text('Add Course'),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
