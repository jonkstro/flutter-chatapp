import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:chatapp/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;
    if (user != null) {
      // não enviar mais mensagens sem texto
      if (_message == '') return;
      await ChatService().save(_message, user);
      // limpar o texto após mandar a mensagem
      _messageController.clear();
      _message = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            // a mensagem vai mudar toda vez que mudar o texto
            onChanged: (value) => setState(() => _message = value),
            onSubmitted: (value) {
              _message.trim().isEmpty ? null : _sendMessage();
            },
            decoration: const InputDecoration(labelText: 'Enviar mensagem...'),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _message.trim().isEmpty ? null : _sendMessage,
        ),
      ],
    );
  }
}
