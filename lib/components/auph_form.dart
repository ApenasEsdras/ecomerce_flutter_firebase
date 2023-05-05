import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    // varioavel para definir uma verificacao do tamanho do dispositivo
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      // sonbreamneto
      elevation: 8,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 320,
        width: deviceSize.width * 0.75,
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              keyboardType: TextInputType.emailAddress,
              // ocultar senha
              obscureText: true,
            ),
            if(_authMode == AuthMode.Signup)
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
              keyboardType: TextInputType.emailAddress,
              // ocultar senha
              obscureText: true,
            ),
          ],
        )),
      ),
    );
  }
}
