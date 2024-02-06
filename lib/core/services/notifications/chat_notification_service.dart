import 'package:chatapp/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  List<ChatNotification> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  // Push Notifications
  Future<void> init() async {
    // É ideal iniciar pelo tratamento da notificação terminated antes das outras!
    await _configureTerminated();
    await _configureForeground();
    await _configureBackground();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    // Solicitar permissão pra notificações
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Quando tiver o app ativo (Foreground)
  Future<void> _configureForeground() async {
    // Só vai configurar se o user permitir
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen(_messageHandler);
    }
  }

  // Quando tiver o app fechado (Background)
  Future<void> _configureBackground() async {
    // Só vai configurar se o user permitir
    if (await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    }
  }

  // Quando tiver o app encerrado (Terinated)
  Future<void> _configureTerminated() async {
    // Só vai configurar se o user permitir
    if (await _isAuthorized) {
      RemoteMessage? initialMsg =
          await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(initialMsg);
    }
  }

  void _messageHandler(RemoteMessage? msg) {
    // se não tiver notificações não faz nada
    if (msg == null || msg.notification == null) return;
    // se tiver notificações vai escutar as mensagens de notificações
    add(ChatNotification(
      title: msg.notification?.title ?? 'Não informado!',
      body: msg.notification?.body ?? 'Não informado!',
    ));
  }
}
