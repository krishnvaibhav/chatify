import 'package:chatify/app/constants/asset_location.dart';
import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
      appBar: AppBar(
        backgroundColor: ColorConstants.darkSecond,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    _titleText(context),
                    _mainImage(context, LOGO1),
                    _inputContainer(
                        context, controller, "Email", _emailValidation),
                    const SizedBox(
                      height: 20,
                    ),
                    _inputContainer(
                        context, controller, "Password", _passwordValidation),
                    !controller.loading.value
                        ? _authButton(context, controller,formKey)
                        : _loader(context),
                    _changeAuthType(context, controller)
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

Widget _titleText(BuildContext context) {
  return Center(
    child: Text(
      TITLE,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: ColorConstants.light,
          ),
    ),
  );
}

Widget _mainImage(BuildContext context, String img) {
  return Container(
    padding: const EdgeInsets.all(15),
    child: Image.asset(img),
  );
}

Widget _inputContainer(BuildContext context, LoginController controller,
    String hintText, String? Function(String?) validation) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextFormField(
      onSaved: (newValue) {},
      validator: (value) => validation(value),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: ColorConstants.light,
            decorationColor: ColorConstants.light,
          ),
      obscureText: hintText == "Password" ? true : false,
      controller: hintText == "Email"
          ? controller.emailController
          : controller.passwordController,
      cursorColor: ColorConstants.light,
      keyboardType:
          hintText == "Email" ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        hintStyle: const TextStyle(color: ColorConstants.light),
      ),
    ),
  );
}

String? _emailValidation(String? value) {
  if (value == null || value.trim().isEmpty || !value.contains('@')) {
    return EMAIL_VALIDATION;
  }
  return null;
}

String? _passwordValidation(String? value) {
  if (value == null || value.trim().length < 6) {
    return PASSWORD_VALIDATION;
  }
  return null;
}

Widget _authButton(BuildContext context, LoginController controller,formKey) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: const BeveledRectangleBorder(),
        ),
        onPressed: () => controller.submit(context,formKey),
        icon: Icon(
          controller.isLogin.value ? Icons.login : Icons.verified_user_rounded,
          color: ColorConstants.darkSecond,
        ),
        label: Text(
          controller.isLogin.value ? "Login" : "Sign up",
          style: const TextStyle(color: ColorConstants.darkSecond),
        ),
      ),
    ),
  );
}

Widget _loader(BuildContext context) {
  return const Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            backgroundColor: ColorConstants.light,
            color: ColorConstants.darkSecond,
          )));
}

Widget _changeAuthType(BuildContext context, LoginController controller) {
  return TextButton(
    onPressed: () => controller.toggleLogin(),
    child: Text(
      controller.isLogin.value ? LOGIN_TO_SIGNUP_TEXT : SIGNUP_TO_LOGIN_TEXT,
      style: const TextStyle(color: ColorConstants.lightOpacity),
    ),
  );
}
