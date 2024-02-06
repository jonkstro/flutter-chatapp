import 'package:chatapp/components/auth_form.dart';
import 'package:chatapp/core/models/auth_form_data.dart';
import 'package:chatapp/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _handleSubmit(AuthFormData formData) async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      if (formData.isLogin) {
        // Login
        try {
          await AuthService().login(
            formData.email,
            formData.password,
          );
        } on FirebaseAuthException catch (error) {
          /// TODO: Refatorar e validar outros erros de Login dentro de Map, igual no IluminaPhb (criar pasta exceptions)
          /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
          // print('code: ${error.code}');
          // print('erro: ${error}');
          if (error.code == 'channel-error') {
            _showError('Preencha email e senha');
          }
          if (error.code == 'invalid-email') {
            _showError('Preencha um email válido');
          }
          if (error.code == 'invalid-credential') {
            _showError('Email ou senha estão incorretos');
          }
        }
      } else {
        // Signup
        /// TODO: Tratar os erros de signup
        await AuthService().signup(
          formData.name,
          formData.email,
          formData.password,
          formData.image,
        );
      }
    } catch (error) {
      // Tratar o erro
      _showError('Ocorreu um erro inesperado: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // Botar a tela interativa quando tiver loading
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          // Quando tiver carregando a página vai ficar "pensando"
          if (_isLoading)
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
