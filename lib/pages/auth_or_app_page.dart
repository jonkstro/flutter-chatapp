import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:chatapp/pages/auth_page.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/loading_page.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Streambuilder é como o Provider (Padrão de projeto observer), sempre
      // que mudar a Stream userChange será notificado e atualizado.
      body: StreamBuilder<ChatUser?>(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            // Se não tiver dados na stream (null) vai pra tela de authpage
            return snapshot.hasData ? const ChatPage() : const AuthPage();
          }
          // TODO: Adicionar uma tela caso dê erro
        },
      ),
    );
  }
}
