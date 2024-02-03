import 'package:chatapp/components/message_bubble.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:chatapp/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    // Sempre que houver mudanças na stream (adicionar mensagens) vai atualizar aqui
    return StreamBuilder(
      // Pegar o stream que tiver configurado na factory (mock ou firebase)
      stream: ChatService().messageStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Se não tiver nenhuma mensagem na stream
          return const Center(
            child: Text('Sem Dados. Vamos conversar?'),
          );
        } else {
          final msgs = snapshot.data!;
          return ListView.builder(
            reverse: true, // mostrar de baixo pra cima
            itemCount: msgs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                key: ValueKey(msgs[index].id),
                message: msgs[index],
                // Verificar se o id da msg é igual do user logado
                belongsToCurrentUser: currentUser?.id == msgs[index].userId,
              );
            },
          );
        }
      },
    );
  }
}
