import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final GlobalKey<SliderDrawerState> key = GlobalKey<SliderDrawerState>();

  RxString? name ;

  void open(){
    key.currentState?.openSlider();
  }

  void close(){
    key.currentState?.closeSlider();
  }

  void logout(){
    key.currentState?.dispose();
    FirebaseAuth.instance.signOut();
  }

  void loadData(){
    name = FirebaseAuth.instance.currentUser?.email!.obs;
  }



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
    print("EMAIL IS !!!!!!! ${FirebaseAuth.instance.currentUser?.email}");
  }

  @override
  void onClose() {
    super.onClose();
  }

}
