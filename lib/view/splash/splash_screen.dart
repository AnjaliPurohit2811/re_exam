import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:re_exam/view/signup/signup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
         Padding(
           padding: const EdgeInsets.only(top: 320,left: 30),
           child: GestureDetector(
             onTap: () {
               Get.to(SignUpScreen());
             },
             child: Container(
               height: 350,
               width: 350,
               decoration: BoxDecoration(
                 image: DecorationImage(image: AssetImage('asset/img/logo.png'))
               ),
             ),
           ),
         )
        ],
      ),
    );
  }
}
