import 'package:flutter/material.dart';
import 'userModel.dart';
enum MessageType { text, image, audio, file }

class Message {
  final int id;
  final String content;
  final String senderId;
  final String receiverId;
  final MessageType type;
  final String? fileUrl;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? sender;
  final User? receiver;

  Message({
    this.id = 0,
    required this.content,
    required this.senderId,
    required this.receiverId,
    this.type = MessageType.text,
    this.fileUrl,
    this.isRead = false,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: _getMessageType(json['type']),
      fileUrl: json['fileUrl'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? User.fromJson(json['receiver']) : null,
    );
  }

  static MessageType _getMessageType(String? type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'file':
        return MessageType.file;
      default:
        return MessageType.text;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type.toString().split('.').last,
      if (fileUrl != null) 'fileUrl': fileUrl,
    };
  }
}