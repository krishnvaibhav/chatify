import 'package:chatify/app/constants/color_constants.dart';
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
          // title: ,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            )
          ],
          backgroundColor: ColorConstants.darkSecond,
          foregroundColor: ColorConstants.light,
        ),
        body: Column(
          children: [
            Obx(
              () => !controller.loading.value
                  ? Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: CircleAvatar(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userData["name"] ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Hey there is use chatify",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
            Expanded(child: _chatMessage(context)),
            _messageInput(context, controller, id)
          ],
        ));
  }
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
        )),
        IconButton(
            onPressed: () {
              controller.handleMessageSubmit(id);
            },
            icon: Icon(Icons.send))
      ],
    ),
  );
}
