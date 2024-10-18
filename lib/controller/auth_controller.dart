




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/auth_service.dart';



class AuthController extends GetxController {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  Future<void> signup(String email, String password) async {
    try {
      bool emails = await AuthServices.authServices.checkEmail(email);
      if (emails) {
        Get.snackbar(
          'Sign Up Failed',
          'Email already in use. Please use a different email.',
        );
      } else {
        await AuthServices.authServices.createAccount(email, password);
        Get.snackbar(
          'Sign Up',
          'Sign Up Successfully',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        e.toString(),
      );
    }
  }
}
