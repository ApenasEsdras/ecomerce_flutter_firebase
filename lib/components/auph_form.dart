import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

// verifica se estou no modo login ou cadastro
enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // para saber um valor de um campo especifico presiso de um controler
  final _passwordController = TextEditingController();

//responsavel por obter infgoprmacoes do formulario
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

// sauvar inputs
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

// informa parte da dela de login q estou
  AuthMode _authMode = AuthMode.login;

// criando metodos para simnplificar o codigo
  bool _isLogin() => _authMode == AuthMode.login;
  bool _issignup() => _authMode == AuthMode.signup;

// funcao que valida escolho de fazer cadastro
  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    // preisase de um provider para poder fazer o post no firebase
    Auth auth = Provider.of(context, listen: false);
    if (_isLogin()) {
      // login
    } else {
      // Registrar
      await auth.signup(
        _authData['email']!,
        _authData['password']!,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // varioavel para definir uma verificacao do tamanho do dispositivo
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      // sonbreamneto
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          // responsavel por obter infgoprmacoes do formulario
          key: _formKey,
          child: Column(
            children: [
              // metodo padao para se fazer formularios
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                // sauvar inputs // caso nao venha valor seta vazio
                onSaved: (password) => _authData['password'] = password ?? '',
                // ocultar senha
                obscureText: true,
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha valida';
                  }
                  return null;
                },
              ),
              // chamada de condiciojal contendo tipo de tela que estou
              if (_issignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  // ocultar senha
                  obscureText: true,
                  // validacao da senha
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          // garante o retorno de uma string
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas diferentes';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 18,
                      )),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTAR',
                  ),
                ),
              // dá u espaco entre o botton e o textBooton baseado em flexBox
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
