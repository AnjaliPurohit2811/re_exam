import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authController.txtFirstName,
                decoration: const InputDecoration(
                  labelText: 'username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xffFBFBFD),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Email / Phone Number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authController.txtEmail,
                decoration: const InputDecoration(
                  labelText: 'email / phone number',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xffFBFBFD),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authController.txtPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'password',
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: Icon(Icons.visibility_outlined),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xffFBFBFD),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Map m1 = {
                    'name': authController.txtFirstName.text,
                    'password': authController.txtPassword.text,
                    'email': authController.txtEmail.text,
                  };

                  authController.signup(
                      authController.txtEmail.text, authController.txtPassword.text);
                  authController.txtEmail.clear();
                  authController.txtPassword.clear();
                  authController.txtFirstName.clear();
                  Get.off(HomeScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 65),
                  child: Container(
                    height: 60,
                    width: 250,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),


              const Padding(
                padding: EdgeInsets.only(top: 20, left: 80),
                child: Row(
                  children: [
                    Text(
                      'Already have account ?',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      ' login',
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
