import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/music_selector/views/music_selector_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/room_controller.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
      appBar: AppBar(
          // title: const Text('RoomView'),
          // centerTitle: true,
        ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => MusicSelectorView());
          },
          child: Text('RoomView is working', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
