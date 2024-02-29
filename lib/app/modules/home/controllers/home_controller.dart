import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../contacts/controllers/contacts_controller.dart';

class HomeController extends GetxController {
  RxString? name;

  final userDb = FirebaseFirestore.instance.collection('users');
  final chatsDb = FirebaseFirestore.instance.collection('chat');
  RxBool loading = false.obs;
  RxMap userData = {}.obs;
  RxBool alert = false.obs;
  RxList idList = [].obs;

  void getIdList() {
    loading.value = true;
    final id = FirebaseAuth.instance.currentUser?.uid;
    userDb.doc(id).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("id ");
        print(data["chats"]);
        idList.value = data["chats"];
        loading.value = false;

        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    loading.value = false;
  }

  Stream<QuerySnapshot> getUserChats(otherUserId) {
    return userDb
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    final chatRoomId = ids.join("_");

    return FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }



  void toggleAlert() {
    alert.value = !alert.value;
  }



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print("Ready!!!!!");
    if (FirebaseAuth.instance.currentUser != null) {
      print("loading user");
      getIdList();
      if (userData["number"] == "") {
        Get.to(() => const ProfilePicView());
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
