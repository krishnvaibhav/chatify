import 'dart:typed_data';

import 'package:chatify/app/constants/asset_location.dart';
import 'package:chatify/app/constants/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/music_selector_controller.dart';

class MusicSelectorView extends GetView<MusicSelectorController> {
  const MusicSelectorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.darkSecond,
        appBar: AppBar(
          backgroundColor: ColorConstants.darkSecond,
          foregroundColor: ColorConstants.light,
          // title: const Text('Select your song'),
          // centerTitle: true,
        ),
        body: Column(
          children: [
            Obx(() => Expanded(
                  child: ListView.builder(
                    itemCount: controller.mySongs.length,
                    itemBuilder: (context, index) {
                      return _songContainer(controller.mySongs[index], context,
                          MusicSelectorController);
                    },
                  ),
                )),
          ],
        ));
  }

  Widget _songContainer(SongModel song, context, MusicSelectorController) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Add your onTap logic here
            controller.selectedSong({
              'id' : song.id,
              'title': song.title,
              'artist': song.artist,
              'filePath': song.filePath,
              'artworkPath': song.artworkPath,
              'duration': song.duration
            });
          },
          splashColor: Colors.grey,
          radius: MediaQuery.of(context).size.width*15 /100,
          child: Row(
            children: [
              song.artworkPath != null
                  ? CircleAvatar(
                foregroundImage: MemoryImage(song!.artworkPath!),
                radius: 25,
              )
                  : const CircleAvatar(
                foregroundImage: AssetImage(SONGS_IMG),
                radius: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                      child: Text(
                        song.title,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                      child: Text(
                        song.artist!,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
