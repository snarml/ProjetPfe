import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatbotWelcome extends StatelessWidget {
  const ChatbotWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "مساعدك الذكي",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // Robot image
                  
                       Image.asset(
                          'images/chatbot_photo.jpg', 
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      
                    const SizedBox(height: 40),
                    // Main text
                    const Text(
                      "أنا جاهز لمساعدتك!\nأخبرني بما تحتاج، لنبدأ معًا.",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 30),
                    // Subtitle text
                    Text(
                      "اسألني عن أي شيء يخطر ببالك. أنا هنا لمساعدتك!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 4, 3, 3),
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Next button at the bottom
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: SizedBox(
              width: 150,
              height: 50,
              child: Container(
                
                child: ElevatedButton(
                  onPressed: () {
                    // Navigation vers la page de chat
                    Get.toNamed('/chatbot_conversation');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6979F8), // Couleur violette du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                
                    ),
                  ),
                  child: const Text(
                    "التالي",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}