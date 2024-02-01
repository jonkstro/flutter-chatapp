import 'package:chatapp/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  // Variáveis das animações
  double _containerHeight = 300;
  bool _isNameVisible = false;
  final Duration duracao = const Duration(milliseconds: 300);

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: AnimatedContainer(
        duration: duracao,
        curve: Curves.easeIn,
        height: _containerHeight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // if (_formData.isSignup)
                AnimatedContainer(
                  // Vai animar uma altura de 60 a 120 quando for signup
                  constraints: BoxConstraints(
                    minHeight: _formData.isLogin ? 0 : 60,
                    maxHeight: _formData.isLogin ? 0 : 120,
                  ),
                  duration: duracao,
                  curve: Curves.linear,
                  child: AnimatedOpacity(
                    duration: duracao,
                    opacity: _isNameVisible ? 1.0 : 0.0,
                    child: TextFormField(
                      key: const ValueKey('name'),
                      onChanged: (value) => _formData.name = value,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: _formData.isLogin
                          ? null
                          : (value) {
                              final name = value ?? '';
                              // Remover espaços em branco no início e no final da string e ver se tem @
                              if (name.trim().isEmpty ||
                                  name.trim().length < 4) {
                                return 'Nome deve ter no mínimo 4 caracteres';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  onChanged: (value) => _formData.email = value,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  validator: _formData.isLogin
                      ? null
                      : (value) {
                          final email = value ?? '';
                          // Remover espaços em branco no início e no final da string e ver se tem @
                          if (email.trim().isEmpty ||
                              !email.contains('@') ||
                              !(email.contains('.com') ||
                                  email.contains('.edu.br'))) {
                            return 'Informe um email válido';
                          }
                          return null;
                        },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  onChanged: (value) => _formData.password = value,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                  validator: _formData.isLogin
                      ? null
                      : (value) {
                          final password = value ?? '';
                          List<String> errors = [];
                          // Verificar se a senha é vazia ou tem menos de 5 caracteres
                          if (password.isEmpty || password.length < 5) {
                            errors.add('Preencha ao menos 5 caracteres');
                          }

                          // Verificar se a senha contém pelo menos uma letra maiúscula
                          if (!password.contains(RegExp(r'[A-Z]'))) {
                            errors.add('Preencha ao menos uma letra maiúscula');
                          }

                          // Verificar se a senha contém pelo menos uma letra minúscula
                          if (!password.contains(RegExp(r'[a-z]'))) {
                            errors.add('Preencha ao menos uma letra minúscula');
                          }

                          // Verificar se a senha contém pelo menos um número
                          if (!password.contains(RegExp(r'[0-9]'))) {
                            errors.add('Preencha ao menos um número');
                          }

                          // Verificar se a senha contém pelo menos um caractere especial
                          if (!password
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            errors
                                .add('Preencha ao menos um caractere especial');
                          }

                          if (errors.isNotEmpty) {
                            setState(() => _containerHeight = 450);
                          }

                          // Se houver erros, retorna a mensagem concatenada; caso contrário, retorna null
                          return errors.isEmpty ? null : errors.join('\n');
                        },
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _formData.isLogin ? 'Entrar' : 'Cadastrar',
                  ),
                  onPressed: () => _submit(),
                ),
                TextButton(
                  child: Text(
                    _formData.isLogin
                        ? 'Criar uma nova conta?'
                        : 'Já possui conta?',
                  ),
                  onPressed: () {
                    setState(() {
                      // Resetar o formulário pra não aparecerem na tela de login
                      _formKey.currentState?.reset();
                      // Exibir o campo nome ou não
                      _isNameVisible = !_isNameVisible;
                      // Alternar entre login e signup
                      _formData.toggleAuthMode();
                      _containerHeight = _formData.isSignup ? 300 : 250;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
