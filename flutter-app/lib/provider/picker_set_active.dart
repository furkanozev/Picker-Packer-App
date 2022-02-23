import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerSetActive {
  int account_id;
  bool picker_active;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/setPickerActive"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(
          {'account_id': this.account_id, 'picker_active': this.picker_active}),
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

  void setPickerActive(bool picker_active) {
    this.picker_active = picker_active;
  }
}
