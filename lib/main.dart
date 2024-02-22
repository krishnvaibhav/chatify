import 'package:chatify/app/constants/text_theme.dart';
import 'package:chatify/app/modules/chat/controllers/chat_controller.dart';
import 'package:chatify/app/modules/contacts/controllers/contacts_controller.dart';
import 'package:chatify/app/modules/home/controllers/home_controller.dart';
import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:chatify/app/modules/localAuthentication/controllers/local_authentication_controller.dart';
import 'package:chatify/app/modules/login/controllers/login_controller.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:chatify/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/profilePic/controllers/profile_pic_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("Firebase initialization error: $e");
    // Handle initialization error, e.g., show an error message and exit the app.
    return;
  }

  // LocalAuthenticationController localAuthController = Get.put(LocalAuthenticationController());
  //
  // print(localAuthController.isAuth);


  // Initialize Controllers
  Get.put(LoginController());
  Get.put(ProfilePicController());
  Get.put(HomeController());
  Get.put(ContactsController());
  Get.put(ChatController());


  runApp(
    GetMaterialApp(
      theme: theme,
      title: "Chatify",
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for connection");
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            print("User is logged in: ${snapshot.data}");
            return const HomeView();
          } else {
            print("User is not logged in");
            return LoginView();
          }
        },
      ),
    ),
  );
}