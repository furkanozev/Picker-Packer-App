import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerOrderPrepareItemDeleteService {
  int id;
  String name;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/deletePickerItemOrder"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({'id': this.id}),
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

  void setItem(int id, String name) {
    this.id = id;
    this.name = name;
  }
}
