import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PackerOrderHistoryDeleteService {
  int order_id;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/PackerOrderHistoryDelete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'order_id': this.order_id,
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

  void setOrderId(int order_id) {
    this.order_id = order_id;
  }
}
