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

  FocusNode chatViewFocusNode = FocusNode();

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
        .add(messageData)
        .then((value) => scrollDown());

    messageController.clear();

    await userDb
        .doc(myId)
        .collection('chats')
        .where("id", isEqualTo: id)
        .get()
        .then(
      (value) {
        print(value.docs.length);
        if (value.docs.isEmpty) {
          print("First first");
          addNewChatUser(myId, id);
        } else {
          print("Not First");
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void addNewChatUser(myId, id) async {
    print("Adding first message");
    try {
      await userDb.doc(myId).collection('chats').add({'id': id});
      await userDb.doc(id).collection('chats').add({'id': myId});
      final HomeController controller = HomeController();
    } catch (err) {
      print(err);
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

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    print("Scroll down");
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  void onInit() {
    super.onInit();
    chatViewFocusNode.addListener(() {
      if (chatViewFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () {
          scrollDown();
        });
      }
    });
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
