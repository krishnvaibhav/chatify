import 'package:get/get.dart';

import '../controllers/music_controller.dart';

class MusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MusicController>(
      () => MusicController(),
    );
  }
}
