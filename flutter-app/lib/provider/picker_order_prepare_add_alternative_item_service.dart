import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PickerOrderPrepareAddAlternativeItemService {
  int item_id, order_id, old_item_id;
  String old_name, new_name;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/addAlternativeItemOrder"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode({
        'item_id': this.item_id,
        'order_id': this.order_id,
        'id': this.old_item_id
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

  void setItem(int item_id, int order_id, String new_name, int old_item_id,
      String old_name) {
    this.item_id = item_id;
    this.order_id = order_id;
    this.old_item_id = old_item_id;
    this.old_name = old_name;
    this.new_name = new_name;
  }
}
