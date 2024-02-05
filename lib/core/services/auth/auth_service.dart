import 'dart:io';

import 'package:chatapp/core/models/chat_user.dart';
import 'package:chatapp/core/services/auth/auth_firebase_service.dart';
import 'package:chatapp/core/services/auth/auth_mock_service.dart';

// Essa classe é abstrata pois servirá como uma interface para os serviços mockados e do firebase
abstract class AuthService {
  // Retornar os dados do user
  ChatUser? get currentUser;
  // Sempre lança novo dado quando mudar o estado do user
  // (Pode mudar pra Provider depois se quiser)
  Stream<ChatUser?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  );
  Future<void> login(
    String email,
    String password,
  );
  Future<void> logout();

  /// criando uma fábrica (factory) para a classe AuthService. O objetivo de uma fábrica é criar
  /// e retornar instâncias de objetos de diferentes tipos, dependendo das condições ou
  /// configurações específicas. Neste caso, a fábrica está sendo utilizada para
  /// fornecer diferentes implementações de serviços de autenticação.
  factory AuthService() {
    /// Onde for chamado AuthService (AuthPage por exemplo) ele irá chamar a implementação que tiver
    /// configurada  abaixo (AuthMockService ou AuthFirebaseService) ao invés de chamar a interface.
    // return AuthMockService();
    return AuthFirebaseService();
  }
}
