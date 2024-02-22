import 'package:chatify/app/constants/color_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
      appBar: AppBar(
        title: _buildProfileInfo(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                controller.loadProfile(id);
              },
              icon: Icon(Icons.call),
            ),
          ),
        ],
        backgroundColor: ColorConstants.darkSecond,
        foregroundColor: ColorConstants.light,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(id, context, controller)),
          _messageInput(context, controller, id)
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return FutureBuilder(
      future: controller.loadProfile(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading profile: ${snapshot.error}');
        } else {
          return _buildProfileWidget();
        }
      },
    );
  }

  Widget _buildProfileWidget() {
    return Obx(
      () => controller.userProfileData.value.isNotEmpty
          ? Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                      foregroundImage:
                          controller.userProfileData.value["url"] != ""
                              ? NetworkImage(
                                  controller.userProfileData.value["url"])
                              : null),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userProfileData.value["name"],
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      controller.userProfileData.value["bio"],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                )
              ],
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget _chatMessage(context) {
    return const Center(
      child: Text(
        'No Message Available',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _messageInput(context, ChatController controller, id) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: ColorConstants.light),
              decoration: const InputDecoration(
                hintText: "Send a message......",
                hintStyle: TextStyle(color: ColorConstants.light),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.handleMessageSubmit(id);
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(id, context, ChatController controller) {
    return StreamBuilder(
      stream: controller.getMessage(FirebaseAuth.instance.currentUser!.uid, id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Please wait.....");
        }

        return ListView(
            children: snapshot.data!.docs
                .map((e) => _buildMessageItem(context, controller, e))
                .toList());
      },
    );
  }

  Widget _buildMessageItem(
      context, ChatController controller, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var sentByMe = data["senderID"] == FirebaseAuth.instance.currentUser!.uid;
    var alignment = sentByMe ? Alignment.centerRight : Alignment.centerLeft;

    var borderRadius = sentByMe
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.zero,
            topLeft: Radius.circular(10))
        : const BorderRadius.only(
            bottomLeft: Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10));

    var color = sentByMe ? ColorConstants.dark : ColorConstants.darkOpacity;

    var crossAlignment =
        sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 50),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: Column(
          crossAxisAlignment: crossAlignment,
          children: [
            Text(
              data["message"],
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              data["timestamp"].toDate().toString().substring(0, 16),
              style: TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
