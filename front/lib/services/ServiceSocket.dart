import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'authServices.dart';
import '../../models/messageModel.dart';

class SocketService {
  static IO.Socket? _socket;
  static final Map<String, Function> _listeners = {};

  // Initialiser la connexion Socket.io
  static Future<IO.Socket> initSocket() async {
    if (_socket != null) {
      return _socket!;
    }

    final token = await AuthService.getToken();
    
    _socket = IO.io(
      'http://127.0.0.1:4000', // URL du serveur backend
      IO.OptionBuilder( )
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('Connecté au serveur Socket.io');
    });

    _socket!.onDisconnect((_) {
      print('Déconnecté du serveur Socket.io');
    });

    _socket!.onError((err) {
      print('Erreur Socket.io: $err');
    });

    return _socket!;
  }

  // Obtenir l'instance Socket.io
  static Future<IO.Socket> getSocket() async {
    if (_socket == null) {
      return await initSocket();
    }
    return _socket!;
  }

  // Écouter les nouveaux messages
  static Future<void> listenForNewMessages(Function(Message) onNewMessage) async {
    final socket = await getSocket();
    
    // Supprimer l'ancien écouteur s'il existe
    if (_listeners.containsKey('newMessage')) {
      socket.off('newMessage');
      _listeners.remove('newMessage');
    }
    
    // Ajouter le nouvel écouteur
    socket.on('newMessage', (data) {
      final message = Message.fromJson(data);
      onNewMessage(message);
    });
    
    _listeners['newMessage'] = onNewMessage;
  }

  // Écouter les messages lus
  static Future<void> listenForReadMessages(Function(int) onMessageRead) async {
    final socket = await getSocket();
    
    if (_listeners.containsKey('messageRead')) {
      socket.off('messageRead');
      _listeners.remove('messageRead');
    }
    
    socket.on('messageRead', (data) {
      final messageId = data['messageId'];
      onMessageRead(messageId);
    });
    
    _listeners['messageRead'] = onMessageRead;
  }

  // Déconnecter Socket.io
  static void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _listeners.clear();
    }
  }
}
