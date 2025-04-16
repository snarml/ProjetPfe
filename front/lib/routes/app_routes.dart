import 'package:bitakati_app/screens/EditProfile.dart';
import 'package:bitakati_app/screens/Home_page.dart';
import 'package:bitakati_app/screens/NavBar.dart';
import 'package:bitakati_app/screens/chatbot_conversation.dart';
import 'package:bitakati_app/screens/chatbot_welcome.dart';
import 'package:bitakati_app/screens/farmin_Plus_Page.dart';
//import 'package:bitakati_app/screens/menuPage.dart';
import 'package:bitakati_app/screens/messagePage.dart';
import 'package:bitakati_app/screens/notification_Page.dart';
import 'package:bitakati_app/screens/panier.dart';
import 'package:bitakati_app/screens/profile.dart';
import 'package:bitakati_app/screens/role.dart';
import 'package:bitakati_app/screens/services.dart';
import 'package:bitakati_app/screens/signIn/login_page.dart';
import 'package:bitakati_app/screens/signIn/signin_screen.dart';
import 'package:bitakati_app/screens/signIn/signup_screen.dart';
import 'package:bitakati_app/screens/signIn/welcome_page.dart';
import 'package:bitakati_app/screens/storePage.dart';
import 'package:bitakati_app/widgets/chatbotmsg.dart';
import 'package:get/get.dart';
import 'package:bitakati_app/screens/diseases_page.dart';
import 'package:bitakati_app/screens/pesticides_page.dart';
import 'package:bitakati_app/screens/solutions_page.dart';
import 'package:bitakati_app/screens/fertilizer_page.dart';


class AppRoutes {
  static final routes = [
    GetPage(name: '/welcome', page: () => WelcomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/sign_in', page: () => SignInScreen()),
    GetPage(name: '/sign_up', page: () => SignUpScreen()),
    GetPage(name: '/home_page', page: () => HomePage()),
    GetPage(name: '/chatbot_msg', page: () => Chatbotmsg()),
    GetPage(name: '/chatbot_welcome', page: () => ChatbotWelcome()),
    GetPage(name: '/chatbot_conversation', page: ()=> ChatbotConversation()),
    GetPage(name: '/profile', page: () => ProfilePage()),
    GetPage(name: '/store', page: () => Storepage()),
    GetPage(name: '/farmingPlus', page: () => FarmingPlusPage()),
    GetPage(name: '/services', page: () => Services()),
    GetPage(name: '/panier', page: () => Panier()),
    GetPage(name: '/notification', page: () => NotificationPage()),
    GetPage(name: '/messagePage', page: () => Messagepage()),
    GetPage(name: '/menu', page: () => NavBar()),
    GetPage(name: '/role', page: () => Role()),



  ];
}