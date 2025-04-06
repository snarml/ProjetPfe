import 'package:bitakati_app/controllers/chat_controller.dart';
import 'package:bitakati_app/screens/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatbotConversation extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController textController = TextEditingController();

  ChatbotConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('!أنا مساعدك الذكي '),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: const Color.fromARGB(255, 78, 186, 83),
            height: 1.5,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 249, 248),
                border: Border.all(
                  color: const Color.fromARGB(255, 189, 188, 188),
                  width: 2.0,
                ),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset('images/robot.png',
                    height: 60, width: 60, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                itemCount: chatController.message.length,
                itemBuilder: (context, index) {
                  final message =
                      chatController.message.reversed.toList()[index];
                  bool isUser = message["role"] == "user";
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color.fromARGB(255, 183, 232, 185)
                            : const Color.fromARGB(255, 247, 219, 219),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message["content"]!,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //ligne au dessus de la boite
                Container(
                  height: 2,
                  color: Color.fromARGB(255, 78, 186, 83),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => CameraPage());
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: '...أكتب رسالتك هنا',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          chatController.addMessage(
                              textController.text, "user");
                          textController.clear();
                        },
                        icon: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
