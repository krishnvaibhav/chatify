import 'package:get/get.dart';

import '../controllers/music_selector_controller.dart';

class MusicSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MusicSelectorController>(
      () => MusicSelectorController(),
    );
  }
}
