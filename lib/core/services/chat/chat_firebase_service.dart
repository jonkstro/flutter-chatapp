import 'dart:async';

import 'package:chatapp/core/models/chat_message.dart';
import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messageStream() {
    final store = FirebaseFirestore.instance;
    // Stream de dados que o Firebase vai mandar sempre que mudar algo na collection
    final snapshots = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        // Ordenar do mais antigo pro mais novo (baixo pra cima)
        .orderBy('createdAt', descending: true)
        .snapshots();
    return snapshots.map((event) {
      // percorrer cada doc dos documentos do snapshot
      return event.docs.map((doc) => doc.data()).toList();
    });

    /// Outra forma de se fazer, usando Stream
    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((event) {
    //     // Sempre que ocorrer um novo evento (salvar uma nova mensagem no Firebase) vai
    //     // ser adicionado a mensagem na Stream
    //     List<ChatMessage> lista = event.docs.map((e) {
    //       // Convertendo de QuerySnapshot para List<ChatMessage>
    //       return e.data();
    //     }).toList();
    //     controller.add(lista);
    //   });
    // });
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );
    final docRef = await store
        .collection('chat')
        .withConverter(
          // Receber Map do Firebase e converter pro Objeto
          fromFirestore: _fromFirestore,
          // Transformando ChatMessage para Map (para salvar no Firebase)
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    return doc.data()!;
  }

  /// MÉTODO SEM CONVERSOR, SE QUISER USAR TBM FUNCIONA
  // @override
  // Future<ChatMessage> save(String text, ChatUser user) async {
  //   final store = FirebaseFirestore.instance;
  //   // Transformando ChatMessage para Map (para salvar no Firebase)
  //   final docRef = await store.collection('chat').add({
  //     'text': text,
  //     'createdAt': DateTime.now().toIso8601String(),
  //     'userId': user.id,
  //     'userName': user.name,
  //     'userImageUrl': user.imageUrl,
  //   });

  //   final doc = await docRef.get();

  //   // Transformado o Map de antes em ChatMessage para retornar o objeto
  //   final data = doc.data()!;
  //   return ChatMessage(
  //     id: doc.id,
  //     text: data['text'],
  //     createdAt: DateTime.parse(data['createdAt']),
  //     userId: data['userId'],
  //     userName: data['userName'],
  //     userImageUrl: data['userImageUrl'],
  //   );
  // }

  // Transformando ChatMessage para Map (para salvar no Firebase)
  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }

  // Receber Map do Firebase e converter pro Objeto
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data()!;
    return ChatMessage(
      // mudar onde tiver 'data' pra 'doc', se der erro
      id: doc.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userId: data['userId'],
      userName: data['userName'],
      userImageUrl: data['userImageUrl'],
    );
  }
}
