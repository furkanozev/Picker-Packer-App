import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerOrderPrepareAddItemService {
  int item_id, order_id;
  String name;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/addItemOrder"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert
          .jsonEncode({'item_id': this.item_id, 'order_id': this.order_id}),
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

  void setItem(int item_id, int order_id, String name) {
    this.item_id = item_id;
    this.order_id = order_id;
    this.name = name;
  }
}
