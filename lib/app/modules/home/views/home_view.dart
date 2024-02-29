import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/chat/controllers/chat_controller.dart';
import 'package:chatify/app/modules/chat/views/chat_view.dart';
import 'package:chatify/app/modules/contacts/views/contacts_view.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/home_controller.dart';
import 'package:chatify/app/constants/text_constants.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => GestureDetector(
              onHorizontalDragEnd: (details) {
                print(details);
                print("Drag");
              },
              child: Container(
                color: ColorConstants.darkSecond,
                child: !controller.loading.value
                    ? _userCardList(controller.idList, controller)
                    : CircularProgressIndicator(),
              ),
            )));
  }
}

Widget _userCardList(otherUserId, HomeController controller) {
  return StreamBuilder(
    stream: controller.getUserChats(otherUserId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Skeletonizer(
            enabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.red,
            ));
      }

      return snapshot.data!.docs.isNotEmpty
          ? ListView(
              children: snapshot.data!.docs
                  .map((e) => _userCard(controller, e.data()))
                  .toList(),
            )
          : const Center(child: Text("No chats Yet"));
    },
  );
}

Widget _userCard(HomeController controller, data) {
  var loading = true;
  String? idValue = data["id"];
  print(idValue);
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(idValue).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        loading = true; // or some loading indicator
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return Container(); // User not found or data doesn't exist
      }
      loading = false;
      return Skeletonizer(
        enabled: loading,
        child: _userCardDesign(
          snapshot.data?["name"] ?? "",
          snapshot.data?["url"] ?? "",
          idValue!,
          controller,
        ),
      );
    },
  );
}

Widget _userCardDesign(String name, String profileImage, String otherUserId,
    HomeController controller) {
  return InkWell(
    onTap: () {
      Get.to(() => ChatView(id: otherUserId));
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(profileImage),
            radius: 30,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                StreamBuilder(
                  stream: controller.getLastMessage(
                    FirebaseAuth.instance.currentUser!.uid,
                    otherUserId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Please wait...");
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Text(
                        "No message yet...",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.lightOpacity,
                        ),
                      );
                    }

                    var lastMessageData = snapshot.data!.docs[0].data();
                    return _lastMessage(lastMessageData);
                  },
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.circle,
              color: ColorConstants.online,
              size: 14,
            ),
          )
        ],
      ),
    ),
  );
}

Widget _lastMessage(e) {
  return Text(
    e["message"],
    style: const TextStyle(fontSize: 12, color: ColorConstants.lightOpacity),
  );
}
