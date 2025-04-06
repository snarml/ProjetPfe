import 'package:bitakati_app/screens/chatbot_welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chatbotmsg extends StatelessWidget {
  const Chatbotmsg({super.key});

  @override
  Widget build(BuildContext context) {
    // Fonction commune de navigation
    void navigateToChatbot() {
      Get.to(() => ChatbotWelcome());
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color(0xFFEAF3FC),
        child: InkWell(
          // Utiliser InkWell au lieu de GestureDetector pour avoir l'effet visuel
          onTap: navigateToChatbot,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icône de flèche - maintenant sans InkWell supplémentaire
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child:
                      Icon(Icons.arrow_back, size: 25, color: Colors.black54),
                ),
                const SizedBox(width: 8),

                // Texte du message
                const Flexible(
                  child: Text(
                    "مرحبا بك في مساعدك الزراعي! كيف يمكنني مساعدتك اليوم؟",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textDirection: TextDirection.rtl,
                  ),
                ),

                const SizedBox(width: 12),

                // Icône du chatbot
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 203, 221, 239),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/robot.png',
                      height: 35,
                      width: 35,
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
