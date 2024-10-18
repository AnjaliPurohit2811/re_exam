import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthServices {
  static AuthServices authServices = AuthServices._();

  AuthServices._();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    print(userCredential.user!.email);
  }

  Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> checkEmail(String email) async {
    try {
      List<String> signInMethods =
      await firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
    User? user = firebaseAuth.currentUser;
    if (user == null) {
      Get.back();
    }
  }
}