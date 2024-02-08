import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _firebase = FirebaseAuth.instance;

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLogin = true.obs;
  final formKey = GlobalKey<FormState>();
  RxBool loading = false.obs;

  @override
  void onInit() {
    // Initialization tasks, if any
    super.onInit();
  }

  @override
  void onReady() {
    // Tasks to perform when the widget is ready
    print("LoginController is ready");
    super.onReady();
  }

  @override
  void onClose() {
    // Cleanup tasks
    emailController.dispose();
    passwordController.dispose();
    if (kDebugMode) {
      print("LoginController closed");
    }
    super.onClose();
  }

  void submit(context) async {
    print(kDebugMode);
    print(kReleaseMode);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    formKey.currentState!.save();
    if (kDebugMode) {
      print(emailController.text);
      print(passwordController.text);
    }

    try {
      loading.value = true;

      if (isLogin.value) {
        await _login(context);
      } else {
        await _signUp(context);
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> _login(context) async {
    try {
      final user = await _firebase.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in ${user.user!.email}")),
      );
    } on FirebaseAuthException catch (err) {
      _handleError(context, err.message ?? "Unknown error occurred");
    }
  }

  Future<void> _signUp(context) async {
    try {
      final userCred = await _firebase.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );
    } on FirebaseAuthException catch (err) {
      _handleError(context, err.message ?? "Unknown error occurred");
    }
  }

  void _handleError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void toggleLogin() {
    isLogin.toggle();
  }
}
