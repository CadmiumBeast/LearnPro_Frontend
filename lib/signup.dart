import 'package:flutter/material.dart';
import 'package:get/get.dart';
import  'package:http/http.dart' as http;
import 'Login.dart';
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String role = 'student';

  var roles = [
    'student',
    'instructor'
  ];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> Register() async {
    String name = nameController.text;
    String email = emailController.text;
    String cpassword = cPasswordController.text;
    String password = passwordController.text;
    String rolepicked = role;

    Map<String, dynamic> userInput = {
      'name' : name,
      'email' : email,
      'c_password' : cpassword,
      'password' : password,
      'role' : rolepicked
    };

    String signupData = jsonEncode(userInput);

    const String apiurl = 'http://10.0.2.2:8000/api/v1/register';
    String result = '';
      try{
        final response = await http.post(
          Uri.parse(apiurl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: signupData
        );
        Get.to(Login());
      }
      catch (e){
        setState(() {
          result = 'Error: $e';
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin:const EdgeInsets.all(20.00),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Signup'),
                const SizedBox(
                  height: 10.00,
                ),
                TextField(
                  controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.00)),
                        )
                      ),
                    ),
                const SizedBox(
                  height: 10.00,
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
                const SizedBox(
                  height: 10.00,
                ),
                TextFormField(
                  controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.00)),
                          ),
                      ),
                ),
                const SizedBox(
                  height: 10.00,
                ),
                TextField(
                  controller: cPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.00)),
                          )
                      ),
                    ),
               const SizedBox(
                  height: 10.00,
                ),
                DropdownButton(
                        value: role,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: roles.map((String roles) {
                          return DropdownMenuItem(
                            value: roles,
                            child: Text(roles),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                          role = newValue!;
                          });
                          },
                        ),
                ElevatedButton(onPressed: ()async {
                  Register();
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  cPasswordController.clear();
                  /*Get.to(const Login());*/
                },
                  child: const Text('Register Now'),
                ),
                TextButton(onPressed: (){
                  Get.to(const Login());},
                    child: Text('Already a User? Login'))
                ],
                ),
          ),
        ),
      ),
    );
  }
}
