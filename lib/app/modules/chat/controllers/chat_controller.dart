import 'package:chatify/app/modules/chat/controllers/chat_model.dart';
import 'package:chatify/app/modules/home/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final userDb = FirebaseFirestore.instance.collection('users');
  RxBool loading = false.obs;
  final TextEditingController messageController = TextEditingController();
  RxMap userProfileData = {}.obs;

  Future<void> loadProfile(id) async {
    loading.value = true;
    final docRef = userDb.doc(id);

    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
        userProfileData.value = data;
        print("Data Stored $userProfileData");

        // Trigger UI update
        update();

        loading.value = false;
        print(loading.value);
      },
      onError: (e) {
        print("Error getting document: $e");
      },
    );
  }

  Future<void> handleMessageSubmit(id) async {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    List<String> ids = [myId, id];
    ids.sort();
    var chatRoomId = ids.join("_");

    final message = messageController.text;

    if (message.trim().isEmpty) {
      return;
    }

    final messageData = Message(
            senderID: myId,
            receiverID: id,
            message: message,
            timestamp: Timestamp.now())
        .toMap();

    FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    messageController.clear();

    bool first = true;
    userDb.where("chats", arrayContains: id).get().then(
      (querySnapshot) {
        print("NOt first");
        first = false;
      },
      onError: (e) => print("Error completing: $e"),
    );

    if (first) {
      print("Adding first message");
      try {
        userDb.doc(myId).update({
          'chats': FieldValue.arrayUnion([id])
        });
        final HomeController controller = HomeController();
        controller.getIdList();
      } catch (err) {
        print(err);
      }
    }
  }

  Stream<QuerySnapshot> getMessage(userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    final chatRoomId = ids.join("_");

    return FirebaseFirestore.instance
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
