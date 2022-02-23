import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/user_login.dart';
import 'package:crypto/crypto.dart';

class UserLoginService {
  String username, password;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'username': this.username,
        'password': this.password,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['result'] == true)
        return await parseJSON(jsonResponse);
      else
        return false;
    } else {
      return false;
    }
  }

  parseJSON(var jsonResponse) async {
    var json = jsonResponse['response'];
    UserLogin user = new UserLogin(json['account_id'], json['mode']);

    return user;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setPassword(String password) {
    this.password = sha256.convert(convert.utf8.encode(password)).toString();
  }
}
