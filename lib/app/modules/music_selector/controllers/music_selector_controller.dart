import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicSelectorController extends GetxController {
  RxList<SongModel> mySongs = <SongModel>[].obs;
  RxMap selectedSong = {}.obs;

  void setSelectedSong(song){
    selectedSong.value = song;
  }

  Future<void> getMusicFiles() async {
    try {
      if (kDebugMode) {
        print("Get music files");
      }
      final audioQuery = OnAudioQuery();
      final songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
      );
      if (kDebugMode) {
        print("Got songs");
      }

      final finalSongs = <SongModel>[];

      for (final song in songs) {
        final artwork = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);

        // Ensure that artwork is not null before adding it to the list
          print(artwork.runtimeType);
          finalSongs.add(SongModel(
            id: song.id,
            title: song.title,
            artist: song.artist,
            filePath: song.uri,
            artworkPath: artwork,
            duration: song.duration
          ));
      }


      print("Got songs final");

      mySongs.value = finalSongs;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching music files: $e");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getMusicFiles();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class SongModel {
  final int id;
  final int? duration;
  final String title;
  final String? artist;
  final String? filePath;
  final Uint8List? artworkPath;

  SongModel({
    required this.id,
    required this.duration,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.artworkPath,
  });
}
