import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class PickerChangePasswordService {
  int account_id;
  String currentPassword, newPassword;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/setPickerPassword"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'account_id': this.account_id,
        'currentPassword': this.currentPassword,
        'newPassword': this.newPassword,
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['result'] == true)
        return true;
      else
        return false;
    } else {
      return false;
    }
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }

  void setChanges(String currentPassword, String newPassword) {
    this.currentPassword =
        sha256.convert(convert.utf8.encode(currentPassword)).toString();
    this.newPassword =
        sha256.convert(convert.utf8.encode(newPassword)).toString();
  }
}
