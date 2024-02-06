import 'dart:io';

import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      // TODO: criar lógica de permanecer logado ou de sair
      // dica: verificar se existe sharedPreferences igual true, aí add essa linha dbx
      // se for false no sharedpreferenses, iniciar com null.
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
    // Inicializa o Firebase com um nome específico ('userSignup') e utiliza as opções da
    // instância Firebase padrão
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );
    // Obtém uma instância do serviço de autenticação do Firebase para a instância inicializada
    // anteriormente (signup - FirebaseApp).
    final auth = FirebaseAuth.instanceFor(app: signup);
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // 1. Upload da foto do usuário
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);

      // 2. atualizar os atributos do usuário
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      // 2.5 fazer o login do usuário, pode deixar comentado se quiser
      await login(email, password);

      // 3. salvar usuário no banco de dados (opcional)
      // Vamos passar o nome e foto por parametro para exibir corretamente nome e foto
      _currentUser = _toChatUser(credential.user!, name, imageUrl);
      await _saveChatUser(_currentUser!);
    }
    // Remove a instância Firebase inicializada anteriormente para liberar recursos.
    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
      // TODO: Adicionar sharedpreferences pra poder continuar ou não logado.
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

  static ChatUser _toChatUser(User user, [String? name, String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
