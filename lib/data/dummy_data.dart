// ignore_for_file: non_constant_identifier_names

import 'package:chatapp/core/models/chat_message.dart';
import 'package:chatapp/core/models/chat_user.dart';

final ChatUser DUMMY_USER = ChatUser(
  id: '1',
  name: 'Goku',
  email: 'goku@email.com',
  imageUrl: 'assets/images/avatar.png',
);

final List<ChatMessage> DUMMY_MESSAGES = [
  ChatMessage(
    id: '1',
    text: 'Bom dia',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    userId: '1',
    userName: 'Goku',
    userImageUrl: 'assets/images/avatar.png',
  ),
  ChatMessage(
    id: '2',
    text: 'Bom dia inseto, tudo joia?',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    userId: '2',
    userName: 'Vegeta',
    userImageUrl: 'assets/images/avatar.png',
  ),
  ChatMessage(
    id: '3',
    text: 'Estou bem, obrigado!',
    createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    userId: '1',
    userName: 'Goku',
    userImageUrl: 'assets/images/avatar.png',
  ),
  ChatMessage(
    id: '4',
    text: 'E você?',
    createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
    userId: '1',
    userName: 'Goku',
    userImageUrl: 'assets/images/avatar.png',
  ),
  ChatMessage(
    id: '5',
    text: 'Tudo sob controle.',
    createdAt: DateTime.now(),
    userId: '2',
    userName: 'Vegeta',
    userImageUrl: 'assets/images/avatar.png',
  ),
];
