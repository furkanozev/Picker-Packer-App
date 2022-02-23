import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PackerChangeProfileService {
  int account_id, age;
  String name, email, phone;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/setPackerProfile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'account_id': this.account_id,
        'name': this.name,
        'email': this.email,
        'age': this.age,
        'phone': this.phone
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

  void setChanges(String name, String email, String age, String phone) {
    this.name = name;
    this.email = email;
    this.age = int.parse(age);
    this.phone = phone;
  }
}
