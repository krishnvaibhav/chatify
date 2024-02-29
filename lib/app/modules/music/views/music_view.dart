import 'package:chatify/app/constants/asset_location.dart';
import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/room/views/room_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/music_controller.dart';

class MusicView extends GetView<MusicController> {
  const MusicView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.darkSecond,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  SONGS_IMG,
                  width: 300,
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: _styledButton(context, "Create Room", () {Get.to(()=>RoomView());})),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: _styledButton(context, "Join Room", () {})),
            )
          ],
        ));
  }

  Widget _styledButton(context, String text, Function ontap) {
    return ElevatedButton(
      onPressed: () {
        ontap();
      },
      child: Text(
        text,
        style: TextStyle(color: ColorConstants.light),
      ),
      style: ElevatedButton.styleFrom(
          shape: BeveledRectangleBorder(),
          fixedSize: Size(300, 50),
          backgroundColor: ColorConstants.dark),
    );
  }
}
