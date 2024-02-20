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
import '../modules/profilePic/bindings/profile_pic_binding.dart';
import '../modules/profilePic/views/profile_pic_view.dart';

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
      page: () => const ChatView(id: '',),
      binding: ChatBinding(),
    ),
  ];
}
