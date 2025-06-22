import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/messageModel.dart';
import '../../models/contact.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/media_option_button.dart';

class ConversationDetailScreen extends StatefulWidget {
  final Contact contact;

  const ConversationDetailScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ConversationDetailScreen> createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _showMediaOptions = false;
  late IO.Socket socket;
  final String currentUserId = "user1";

  @override
  void initState() {
    super.initState();
    _initSocket();
    _loadMessages();
  }

  void _initSocket() {
    socket = IO.io(
      'http://127.0.0.1:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Connecté au serveur Socket.io');
      socket.emit('joinUser', currentUserId);
    });

    socket.on('newMessage', (data) {
      if (mounted) {
        setState(() {
          _messages.insert(0, Message.fromJson(data));
        });
      }
    });

    socket.onDisconnect((_) => print('Déconnecté'));
    socket.onError((err) => print('Erreur Socket.io: $err'));
  }

  Future<void> _loadMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/api/messages/${widget.contact.id}'),
        headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _messages.addAll(data.map((e) => Message.fromJson(e)).toList());
        });
      }
    } catch (e) {
      print('Erreur chargement messages: $e');
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = Message(
      content: _messageController.text,
      senderId: currentUserId,
      receiverId: widget.contact.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      type: MessageType.text,
    );

    socket.emit('privateMessage', message.toJson());

    setState(() {
      _messages.insert(0, message);
      _messageController.clear();
    });
  }

  Future<void> _sendImage(String imagePath) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:4000/api/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imagePath));

      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final imageUrl = jsonDecode(responseData)['imageUrl'];

        final message = Message(
          content: 'Nouvelle image',
          senderId: currentUserId,
          receiverId: widget.contact.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          type: MessageType.image,
          fileUrl: imageUrl,
        );

        socket.emit('privateMessage', message.toJson());

        setState(() {
          _messages.insert(0, message);
          _showMediaOptions = false;
        });
      }
    } catch (e) {
      print('Erreur envoi image: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      await _sendImage(pickedFile.path);
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(widget.contact.name, textDirection: TextDirection.rtl),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  message: message,
                  isMe: message.senderId == currentUserId,
                );
              },
            ),
          ),
          if (_showMediaOptions) _buildMediaOptions(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMediaOptions() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaOptionButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            onTap: () => _pickImage(ImageSource.camera),
          ),
          MediaOptionButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showMediaOptions ? Icons.close : Icons.add,
              color: Colors.green,
            ),
            onPressed: () {
              setState(() {
                _showMediaOptions = !_showMediaOptions;
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.green),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}