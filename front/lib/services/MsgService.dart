import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authServices.dart';
import '../screens/communication/messageSearchScreen.dart';
import '../../models/messageModel.dart';

class MessageService {
  static const String baseUrl = 'http://127.0.0.1:4000';

  // Récupérer les messages avec un utilisateur spécifique
  static Future<List<Message>> getMessages(String receiverId ) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$receiverId' ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = data['data']['messages'] as List;
        return messages.map((msg) => Message.fromJson(msg)).toList();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des messages: $e');
      return [];
    }
  }
  // Envoyer un message texte
  static Future<Message?> sendTextMessage(String content, String receiverId) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/messages' ),
        headers: headers,
        body: jsonEncode({
          'content': content,
          'receiverId': receiverId,
          'type': 'text',
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Message.fromJson(data['data']['message']);
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'envoi du message: $e');
      return null;
    }
  }

  // Envoyer un message avec fichier
  static Future<Message?> sendFileMessage(String filePath, String receiverId, MessageType type) async {
    try {
      final token = await AuthService.getToken();
      final uri = Uri.parse('$baseUrl/messages/upload');
      final request = http.MultipartRequest('POST', uri )
        ..headers.addAll({'Authorization': 'Bearer $token'})
        ..files.add(await http.MultipartFile.fromPath('file', filePath ))
        ..fields['receiverId'] = receiverId
        ..fields['type'] = type.toString().split('.').last
        ..fields['content'] = 'Nouveau ${type.toString().split('.').last}';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Message.fromJson(data['data']['message']);
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'envoi du fichier: $e');
      return null;
    }
  }

  // Marquer un message comme lu
  static Future<bool> markMessageAsRead(int messageId) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/messages/$messageId/read' ),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors du marquage du message comme lu: $e');
      return false;
    }
  }
}
