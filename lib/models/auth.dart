import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/constants.dart';

class Auth with ChangeNotifier {
  // valores opcionais
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  // verifica se esta autenticado
  bool get isAuth {
    // verifica se a data de expiracao é depois de agora
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  // retorno dos dados caso de serto a entrada das chaves corretas
  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  // chamada padrao das chaves segundo o firebase
  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    // url de acesso
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Constants.webApiKey}';
    // capitura das chaves
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);
    // busca e leva o erro para a exeption
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];

// coloca uma data de expiracao para o token
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      // faz op retorno e gera a navegacao entre as paginas
      notifyListeners();
    }

    print(body);
  }

// resposavel por fazer as reqwuisicoes
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
