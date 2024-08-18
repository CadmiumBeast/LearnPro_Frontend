import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnpro_frontend/instructorHome.dart';
import 'package:learnpro_frontend/signup.dart';
import 'package:learnpro_frontend/studentHome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errormessage = '';
  static String token = '';
  static String userRole = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> Signin() async{
      String email = emailController.text;
      String password = passwordController.text;

      Map<String, dynamic> userInput = {
        'email': email,
        'password': password,
      };

      String signinData = jsonEncode(userInput);
      const String apiurl = 'http://10.0.2.2:8000/api/v1/login';

      String result = '';
      try{
        final response = await http.post(
            Uri.parse(apiurl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: signinData
        );

        if(response.statusCode == 200 || response.statusCode == 201){
          final responseData = jsonDecode(response.body);

          if(responseData['success'] == true){
            setState(() {
              token = responseData['data']['token'];
              userRole = responseData['data']['role'];
            });
            if(userRole == 'student'){
              Get.offAll(HomeStudent(token: token));
            }else{
              Get.offAll(HomeInstructor(token: token));
            }
          }else{
            print('Login failed: ${responseData['message']}');
          }

        }else{
          print(Exception('Failed to post data')) ;
        }
      }
      catch (e){
        setState(() {
          result = 'Error: $e';
        });
      }

  }
  Widget _errorMessage(){
    return Text(errormessage == '' ? '' : 'hmm ? $errormessage!');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login'),
                SizedBox(
                  height: 20.00,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.00)),
                      )
                  ),
                ),
                SizedBox(
                  height: 20.00,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.00)),
                    ),
                  ),
                ),
                _errorMessage(),
                SizedBox(
                  height: 20.00,
                ),
                ElevatedButton(onPressed: (){
                  Signin();
                }, child: Text('Log-in')),
                TextButton(onPressed: (){
                  Get.to(const Signup());},
                    child: Text('Dont have a Account? Signup'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
