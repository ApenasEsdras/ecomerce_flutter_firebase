import 'dart:math';

import 'package:flutter/material.dart';

import '../components/auph_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack == permite sobrepor elementos
      body: Stack(
        children: [
          Container(
            // define o gradiente
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x7D75D3FF),
                  Color.fromARGB(224, 154, 117, 255),
                ],
                // definie a posicao do gradiente
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              // semelhantes ao justfyContente:
              // centralizar no eixo principal
              crossAxisAlignment: CrossAxisAlignment.center,
              // alinhar elemestos q estao em, coluna vertical ao centro
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 70,
                  ),
                  // fazer rotsacao no eixo Z // Cascade operartion == concatena void
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent.shade200,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Minha Loja',
                    // para definir estilo de fonte usamos o TextStyle
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: 'Anton',
                      color: Colors.white,
                    ),
                  ),
                ),
                const AuthForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ++++++++++++++++++++++++++++++++++++ //

// Exemplo usado para explicar o cascade operator
// void main() {
//   List<int> a = [1, 2, 3];
//   a.add(4);
//   a.add(5);
//   a.add(6);

//   // cascade operator!
//   a..add(7)..add(8)..add(9);

//   print(a);
// }
