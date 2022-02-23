import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/picker_order.dart';

class PickerOrdersService {
  int account_id;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/getPickerOrder"),
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
        return await parseJSON(jsonResponse);
      else
        return false;
    } else {
      return false;
    }
  }

  parseJSON(var jsonResponse) async {
    var json = jsonResponse['response'];
    List<Picker_Order> listOrder = new List<Picker_Order>();

    for (var order in json) {
      listOrder.add(Picker_Order(order['item_amount'], order['order_id'],
          order['date'], order['name'], order['note'], order['phone']));
    }

    return listOrder;
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }
}
