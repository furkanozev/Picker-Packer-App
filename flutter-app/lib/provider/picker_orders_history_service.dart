import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picker_packer/model/picker_order_history.dart';

class PickerOrdersHistoryService {
  int account_id;

  request() async {
    var response = await http.post(
      Uri.parse("https://pickerpacker.herokuapp.com/getPickerOrderHistory"),
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
    List<Picker_Order_History> listOrder = new List<Picker_Order_History>();

    for (var order in json) {
      listOrder.add(Picker_Order_History(
          order['item_amount'],
          order['order_id'],
          order['date'],
          order['name'],
          order['note'],
          order['phone'],
          order['status'],
          order['price_distance']));
    }

    return listOrder;
  }

  void setAccountId(int account_id) {
    this.account_id = account_id;
  }
}
