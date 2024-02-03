import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:chatapp/data/dummy_data.dart';

// Implementação mockada da auth_service como um serviço fake
class AuthMockService implements AuthService {
  // User de teste para iniciar logado, vai ser pego em dummy data (dados mockados)
  static final ChatUser _defaultUser = DUMMY_USER;
  // Statis quer dizer q a variavel pertence à classe, e não à instancia
  // O Map vai ser static pois queremos usar sempre a mesma instancia
  static Map<String, ChatUser> _users = {
    // Só pra iniciar o app logado, pode remover essa linha depois
    _defaultUser.email: _defaultUser,
  };
  // Da mesma forma o user logado, só vamos ter 1 instancia dele
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    // Iniciar adicionando um usuário nulo. Pode mudar pra buscar dentro de
    // um localStorage como sharedPreferences por exemplo.
    // _updateUser(null);
    _updateUser(_defaultUser); // Só pra iniciar o app logado
  });

  @override
  // TODO: implement currentUser
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> login(String email, String password) async {
    // Vai buscar no Map pelo email passado e adicionar no update
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    // vai zerar o user atual e botar um novo dado null na stream
    _updateUser(null);
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      // se não receber a imagem do formData vai botar uma imagem padrão
      imageUrl: image?.path ?? 'assets/images/avatar.png',
    );

    // putIfAbsent == se não tiver o email cadastrado vai adicionar, senão não.
    _users.putIfAbsent(email, () => newUser);
    // Fazer login após registrar, pode mudar se quiser seguir outra lógica
    _updateUser(newUser); // Setar o user atual como o que foi criado
  }

  // Atualizar o usuario no stream
  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
