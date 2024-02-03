import 'package:chatapp/core/services/notifications/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNotificationService>(context);
    final items = service.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Notificações',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: service.itemsCount,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].title),
            subtitle: Text(items[index].body),
            onTap: () => service.remove(index),
          );
        },
      ),
    );
  }
}
