import 'package:bitakati_app/screens/profile/EditProfile.dart';
import 'package:bitakati_app/screens/Home_page.dart';
import 'package:bitakati_app/screens/Dashboard.dart';
import 'package:bitakati_app/screens/chatbot_conversation.dart';
import 'package:bitakati_app/screens/chatbot_welcome.dart';
import 'package:bitakati_app/screens/filaha/diseases_page.dart';
import 'package:bitakati_app/screens/filaha/farmin_Plus_Page.dart';
import 'package:bitakati_app/screens/messagePage.dart';
import 'package:bitakati_app/screens/notification_Page.dart';
import 'package:bitakati_app/screens/notification_detail_page.dart';
import 'package:bitakati_app/screens/panier.dart';
import 'package:bitakati_app/screens/profile/profile.dart';
import 'package:bitakati_app/screens/role.dart';
import 'package:bitakati_app/screens/prestataire/services.dart';
import 'package:bitakati_app/screens/signIn/login_page.dart';
import 'package:bitakati_app/screens/signIn/signin_screen.dart';
import 'package:bitakati_app/screens/signIn/signup_screen.dart';
import 'package:bitakati_app/screens/signIn/verification_code.dart';
import 'package:bitakati_app/screens/signIn/welcome_page.dart';
import 'package:bitakati_app/screens/storePage.dart';
import 'package:bitakati_app/widgets/chatbotmsg.dart';
import 'package:bitakati_app/widgets/navigation_bar.dart';
import 'package:get/get.dart';
import 'package:bitakati_app/screens/filaha/pesticides_page.dart';
import 'package:bitakati_app/screens/filaha/solutions_page.dart';
import 'package:bitakati_app/screens/storePage.dart';
import 'package:bitakati_app/screens/filaha/fertilizer_page.dart';
import 'package:bitakati_app/screens/filaha/fertilizer_detail_page.dart';
import 'package:bitakati_app/screens/filaha/diseases_detail_page.dart';
import 'package:bitakati_app/screens/filaha/diseases_page.dart';
import 'package:bitakati_app/screens/filaha/solutions_detail_page.dart';
import 'package:bitakati_app/screens/filaha/solutions_page.dart';

class AppRoutes {
  static const String homePage = '/home_page';
  static const String services = '/services';
  static const String store = '/store';
  static const String farmingPlus = '/farmingPlus';
  static const String profile = '/profile';

    static final routes = [
      GetPage(name: '/', page: () => Navigationbar()),
      GetPage(name: '/welcome', page: () => WelcomePage()),
      GetPage(name: '/login', page: () => LoginPage()),
      GetPage(name: '/sign_in', page: () => SignInScreen()),
      GetPage(name: '/sign_up', page: () => SignUpScreen()),
      GetPage(name: homePage, page: () => HomePage()),
      GetPage(name: '/chatbot_msg', page: () => Chatbotmsg()),
      GetPage(name: '/chatbot_welcome', page: () => ChatbotWelcome()),

      GetPage(name: '/chatbot_conversation', page: ()=> ChatbotConversation()),
      GetPage(name: '/profile', page: () => ProfilePage()),
      GetPage(name: '/store', page: () => StorePage()),
      GetPage(name: '/farmingPlus', page: () => FarmingPlusPage()),
      GetPage(name: '/services', page: () => Services()),

      GetPage(name: '/chatbot_conversation', page: () => ChatbotConversation()),
      GetPage(name: profile, page: () => ProfilePage()),
      GetPage(name: store, page: () => StorePage()),
      GetPage(name: farmingPlus, page: () => FarmingPlusPage()),
      GetPage(name: services, page: () => Services()),
      GetPage(name: '/panier', page: () => Panier()),
      //GetPage(name: '/notification', page: () => NotificationPage()),
      //GetPage(name: '/NotificationPage', page: () => NotificationDetailPage(message: '',)),
      GetPage(name: '/messagePage', page: () => Messagepage()),
      GetPage(name: '/menu', page: () => NavBar()),
      GetPage(name: '/role', page: () => Role()),
      GetPage(name: '/editProfile', page: () => Editprofile()),
      GetPage(name: '/diseases', page: () => DiseasesPage()),
      GetPage(
        name: '/diseases_detail',
        page: () {
          final args = Get.arguments;
          return DiseaseDetailPage(diseaseData: args['diseaseData']);
        },
      ),
      GetPage(name: '/fertilizer', page: () => FertilizerPage()),
      GetPage(name: '/solutions', page: () => SolutionsPage()),
      GetPage(name: '/pesticides', page: () => PesticidesPage()),
    
      GetPage(
        name: '/verify',
        page: () {
          final args = Get.arguments;
          return VerificationCode(phone: args['phone'], token: args['token']);
        },
      ),
    ];
}



