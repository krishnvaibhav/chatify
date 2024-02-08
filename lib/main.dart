import 'package:chatify/app/constants/text_theme.dart';
import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:chatify/app/modules/login/controllers/login_controller.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.put(LoginController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    GetMaterialApp(
      theme: theme,
      title: "Chatify",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges() ,builder: (context, snapshot) {
      //   if(snapshot.hasData){
      //     return HomeView();
      //   }
      //   return LoginView();
      // },),
    ),
  );
}

