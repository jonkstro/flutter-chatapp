import 'dart:async';
import 'dart:math';

import 'package:chatapp/core/models/chat_message.dart';
import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  // novamente usamos static pois vão pertencer à classe e não à instancia
  // vai ser pego em dummy data (dados mockados)
  // static final List<ChatMessage> _msgs = DUMMY_MESSAGES;
  static final List<ChatMessage> _msgs = [];

  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    // Adicionar no stream a lista de mensagens
    controller.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messageStream() {
    // Retornando a stream criada acima
    return _msgStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );
    // Adicionar a nova mensagem na lista de mensagens
    _msgs.add(newMessage);
    // Adicionar a nova lista de mensagens na stream
    // o reversed é pra adicionar por ultimo
    _controller?.add(_msgs.reversed.toList());
    // Retornar a nova mensagem, respeitando a interface
    return newMessage;
  }
}
