import 'package:chatapp/components/messages.dart';
import 'package:chatapp/components/new_message.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:chatapp/core/services/notifications/chat_notification_service.dart';
import 'package:chatapp/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          const SizedBox(width: 15),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ));
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    // Pegar a qtd de itens de notificações. Listen = true pra atualizar o contador
                    '${Provider.of<ChatNotificationService>(context).itemsCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: const SafeArea(
        // Ao envolver seus widgets com SafeArea, você garante que o conteúdo não seja cortado ou
        // obscurecido por elementos como a barra de status, a barra de navegação ou outros
        // elementos do sistema.
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),

      /// SÓ PRA TESTAR SE TÁ SUBINDO AS NOTIFICAÇÕES!!!
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   shape: const CircleBorder(), // Deixar redondo
      //   // shape: BeveledRectangleBorder(), // Deixar quadrado
      //   /// Igual vem no material3:
      //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     print('object');
      //     Provider.of<ChatNotificationService>(context, listen: false).add(
      //       ChatNotification(
      //         title: 'Mais uma notificação!',
      //         body: 'Numero aleatório: ${Random().nextDouble().toString()}',
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
