import 'dart:io';

import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;
    // 1 - Upload da foto do usuario
    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);
    // 2 - Atualizar os atributos do usuário
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageUrl);
    // 3 - Salvar o user no banco de dados (opcional nessa aplicação)
    await _saveChatUser(
      _toChatUser(
        credential.user!,
        imageUrl,
      ),
    );
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;
    // Referenciar o storage
    final storage = FirebaseStorage.instance;
    // O caminho que vai salvar a imagem
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    // Retornar o Future de String da URL da imagem
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    // definir a instancia do firestore
    final store = FirebaseFirestore.instance;
    // definir o id do documento que vai salvar e nome da "tabela"
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
