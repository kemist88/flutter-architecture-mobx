import 'package:flutter_architecture/src/helpers/http/http_helper.dart';
import 'package:flutter_architecture/src/helpers/storage/storage_helper.dart';
import 'package:flutter_architecture/src/helpers/storage/storage_keys.dart';
import 'package:flutter_architecture/src/models/response_model.dart';
import 'package:flutter_architecture/src/models/usuario_model.dart';
import './base//endpoints.dart' as Endpoints;

class AuthRepository {
  Future<ResponseModel> login(String login, String senha) async {
    ResponseModel response = ResponseModel();
    UsuarioModel user;

    final String url = Endpoints.login.auth;

    final payload = {
      login, 
      senha
    };
    
    final retAuth = HttpHelper.post(url, body: payload);

    await retAuth.then((res) {
      String token = res.data["access_token"];
      StorageHelper.set(StorageKeys.token, token);
      StorageHelper.set(StorageKeys.login, login);
      StorageHelper.set(StorageKeys.senha, senha);

      user = UsuarioModel.fromJson(res.data);

      response.status = res.statusCode;
      response.data = user;
      response.message = res.statusMessage;
    })
    .catchError((e) {
      StorageHelper.set(StorageKeys.token, "");
      StorageHelper.set(StorageKeys.login, "");
      StorageHelper.set(StorageKeys.senha, "");

      print("e -> $e");
      
      response.status = 500;
      response.data = e;
      response.message = "Usuário não encontrado";
    });
    
    return response;
  }
}
