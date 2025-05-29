import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MessageType { text, image, audio, file }

class Message {
  final String text;
  final String sender;
  final DateTime time;
  final MessageType type;

  Message({
    required this.text,
    required this.sender,
    required this.time,
    this.type = MessageType.text,
  });
}

class ConversationController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  final RxBool showMediaOptions = false.obs;
  final String contactName;
  final String contactImage;

  ConversationController({required this.contactName, required this.contactImage});

  @override
  void onInit() {
    super.onInit();
    // Charger les messages initiaux
    messages.assignAll(demoMessages);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void toggleMediaOptions() {
    showMediaOptions.toggle();
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    messages.insert(
      0,
      Message(
        text: messageController.text,
        sender: 'me',
        time: DateTime.now(),
        type: MessageType.text,
      ),
    );
    messageController.clear();
  }

  void sendMedia(String type) {
    showMediaOptions.value = false;
    
    final messageType = type == 'audio' 
        ? MessageType.audio 
        : type == 'camera' || type == 'gallery'
          ? MessageType.image
          : MessageType.file;

    messages.insert(
      0,
      Message(
        text: '',
        sender: 'me',
        time: DateTime.now(),
        type: messageType,
      ),
    );
  }
}

final List<Message> demoMessages = [
  Message(
    text: 'مرحبا! كيف حالك؟',
    sender: 'them',
    time: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Message(
    text: 'أنا بخير، شكرا لسؤالك. وأنت كيف حالك؟',
    sender: 'me',
    time: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  Message(
    text: '',
    sender: 'them',
    time: DateTime.now().subtract(const Duration(minutes: 3)),
    type: MessageType.image,
  ),
  Message(
    text: 'هل رأيت هذه الصورة؟',
    sender: 'them',
    time: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  Message(
    text: '',
    sender: 'me',
    time: DateTime.now().subtract(const Duration(minutes: 1)),
    type: MessageType.audio,
  ),
];