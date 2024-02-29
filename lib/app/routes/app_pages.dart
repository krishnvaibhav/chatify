import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/contacts/bindings/contacts_binding.dart';
import '../modules/contacts/views/contacts_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/localAuthentication/bindings/local_authentication_binding.dart';
import '../modules/localAuthentication/views/local_authentication_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/music/bindings/music_binding.dart';
import '../modules/music/views/music_view.dart';
import '../modules/music_selector/bindings/music_selector_binding.dart';
import '../modules/music_selector/views/music_selector_view.dart';
import '../modules/profilePic/bindings/profile_pic_binding.dart';
import '../modules/profilePic/views/profile_pic_view.dart';
import '../modules/room/bindings/room_binding.dart';
import '../modules/room/views/room_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_PIC,
      page: () => const ProfilePicView(),
      binding: ProfilePicBinding(),
    ),
    GetPage(
      name: _Paths.LOCAL_AUTHENTICATION,
      page: () => const LocalAuthenticationView(),
      binding: LocalAuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTS,
      page: () => const ContactsView(),
      binding: ContactsBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(
        id: '',
      ),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.MUSIC,
      page: () => const MusicView(),
      binding: MusicBinding(),
    ),
    GetPage(
      name: _Paths.ROOM,
      page: () => const RoomView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: _Paths.MUSIC_SELECTOR,
      page: () => const MusicSelectorView(),
      binding: MusicSelectorBinding(),
    ),
  ];
}
