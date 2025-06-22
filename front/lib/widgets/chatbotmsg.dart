import 'package:bitakati_app/screens/chatbot_welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chatbotmsg extends StatelessWidget {
  const Chatbotmsg({super.key});

  @override
  Widget build(BuildContext context) {
    // Fonction de navigation
    void navigateToChatbot() {
      Get.to(() => ChatbotWelcome());
    }

    return Align(
      alignment: Alignment.centerRight,
      
        
        child: InkWell(
          onTap: navigateToChatbot,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Container(
              // mettre un espace entre le search bar et le chatbot 
              margin: const EdgeInsets.only(top: 10),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icône de flèche
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
            
                  // Texte du message
                  Flexible(
                    child: Text(
                      "مرحباً بك في مساعدك الزراعي! كيف يمكنني مساعدتك اليوم؟",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(width: 12),
            
                  // Icône du chatbot avec animation
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/robot.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
    );
  }
}
