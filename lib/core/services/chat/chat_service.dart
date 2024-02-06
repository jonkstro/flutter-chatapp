import 'package:chatapp/core/models/chat_message.dart';
import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/chat/chat_firebase_service.dart';

abstract class ChatService {
  // Sempre que receber uma nova mensage, vai receber os valores
  Stream<List<ChatMessage>> messageStream();
  Future<ChatMessage> save(String text, ChatUser user);

  factory ChatService() {
    // return ChatMockService();
    return ChatFirebaseService();
  }
}
