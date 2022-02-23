import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerOrderHistoryDeleteAllService {
  int account_id;

  request() async {
    var response = await http.post(
      Uri.parse(
          "https://pickerpacker.herokuapp.com/PickerOrderHistoryDeleteAll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'account_id': this.account_id,
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
}
